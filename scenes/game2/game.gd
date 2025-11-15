extends Control

## { <Lane index>: [<ダイス合計値>, ...], ... }
const LANE_NUMBERS := {
    0: [3, 4, 5],
    1: [6, 7],
    2: [8, 9],
    3: [10, 11],
    4: [12, 13],
    5: [14, 15],
    6: [16, 17, 18],
}
## { <Lane index>: [<add>, ...], ... }
const LANE_ADD := {
    0: 5,
    1: 3,
    2: 2,
    3: 1,
    4: 2,
    5: 3,
    6: 5,
}

var temp := 0:
    set(v):
        temp = v
        label_temp.text = str(v)
var score := 0:
    set(v):
        score = v
        label_score.text = str(v)
var target := 0:
    set(v):
        target = v
        label_target.text = str(v)

var turn := 0:
    set(v):
        turn = v
        label_turn.text = str(v)
var stage := 0

var roll_max := 0
var roll := 0:
    set(v):
        roll = v
        _refresh_roll_lamps()
var pick_max := 0
var pick := 0:
    set(v):
        pick = v
        _refresh_pick_lamps()

var dice_numbers := [0, 0, 0]:
    set(v):
        dice_numbers = v
        label_dice_a.text = str(v[0])
        label_dice_b.text = str(v[1])
        label_dice_c.text = str(v[2])

@onready var lanes: Control = %Lanes
@onready var roll_lamps: Control = %RollLamps
@onready var pick_lamps: Control = %PickLamps

@onready var button_roll: Button = %ButtonRoll
@onready var button_pick: Button = %ButtonPick
@onready var button_end: Button = %ButtonEnd

@onready var label_temp: Label = %LabelTemp
@onready var label_score: Label = %LabelScore
@onready var label_target: Label = %LabelTarget
@onready var label_turn: Label = %LabelTurn
@onready var label_stage: Label = %LabelStage
@onready var label_dice_a: Label = %LabelDiceA
@onready var label_dice_b: Label = %LabelDiceB
@onready var label_dice_c: Label = %LabelDiceC


func _ready() -> void:
    print("[Game] _ready()")
    button_roll.pressed.connect(_on_button_roll_pressed)
    button_pick.pressed.connect(_on_button_pick_pressed)
    button_end.pressed.connect(_on_button_end_pressed)

    for i: int in lanes.get_child_count():
        var lane: Lane = lanes.get_child(i)
        lane.numbers = LANE_NUMBERS[i]
        lane.add = LANE_ADD[i]
        lane.score = 1
        lane.pickable = false
        lane.picked = false
        lane.target = false

    temp = _get_temp()
    score = 0
    target = 1000

    turn = 1
    stage = 1

    roll_max = 3
    roll = roll_max
    button_roll.disabled = false

    pick_max = 2
    pick = pick_max
    button_pick.disabled = true
    button_pick.visible = true
    button_end.visible = false


func _on_button_roll_pressed() -> void:
    print("[Game] _on_button_roll_pressed()")
    if roll <= 0:
        return

    # レーンをリセットする
    for i: int in lanes.get_child_count():
        var lane: Lane = lanes.get_child(i)
        # pickable: picked 以外
        if not lane.picked:
            lane.pickable = false
        lane.target = false

    # ボタンを無効化する
    button_roll.disabled = true

    # ロール回数を減らす
    roll -= 1

    # ダイスを振る
    var tween := create_tween()
    tween.set_loops(10)
    tween.tween_callback(func() -> void:
        dice_numbers = [
            randi_range(1, 6),
            randi_range(1, 6),
            randi_range(1, 6),
        ]
    )
    tween.tween_interval(0.05)
    await tween.finished

    # ロール回数がある場合: ボタンを戻す
    if 0 < roll:
        button_roll.disabled = false

    # ダイスの合計値のレーンに対して……
    # NOTE: 複数の可能性を取るかもなので Array にしている
    var dice_number_sums: Array[int] = [dice_numbers[0] + dice_numbers[1] + dice_numbers[2]]
    for sum in dice_number_sums:
        var target_index := _get_lane_index(sum)
        var lane: Lane = lanes.get_child(target_index)
        # ピック回数がある場合
        if 0 < pick:
            # レーンがピックされていない場合: pickable
            if not lane.picked:
                lane.pickable = true
        # ピック回数がない場合
        else:
            lane.target = true
            # ピックされている場合
            if lane.picked:
                # レーンのスコアを加算する
                lane.add_score()
                temp = _get_temp()
                # ロール回数を戻す
                roll = roll_max
                button_roll.disabled = false
            # ピックされていない場合
            else:
                # ロール回数がある場合: 何もしない
                # NOTE: リロールするかターンを終えるか選ぶ
                if 0 < roll:
                    pass
                # ロール回数がない場合: 失敗
                else:
                    # TODO: すぐ切り替わって分からんのでちょっと待つか 表示出す
                    _turn_next(false)
                    return

    # ピック回数がある場合: ボタンを戻す
    # NOTE: 初期状態, ピック時, ターン移行時 に無効になりここで戻る
    if 0 < pick:
        button_pick.disabled = false


func _on_button_pick_pressed() -> void:
    print("[Game] _on_button_pick_pressed()")
    if pick <= 0:
        return

    # ボタンを無効化する
    button_pick.disabled = true

    # ピック回数を減らす
    pick -= 1
    # ピック回数がなくなった場合:
    if pick == 0:
        button_pick.visible = false
        button_end.visible = true

    # ロール回数を戻す
    roll = roll_max
    button_roll.disabled = false

    # Lane
    for i: int in lanes.get_child_count():
        var lane: Lane = lanes.get_child(i)
        if lane.pickable:
            lane.pickable = false
            lane.picked = true


func _on_button_end_pressed() -> void:
    _turn_next(true)


func _turn_next(success: bool) -> void:
    print("[Game] _turn_next(success: %s)" % [success])
    turn += 1

    # ロールをリセットする
    roll = roll_max
    button_roll.disabled = false
    # ピックをリセットする
    pick = pick_max
    button_pick.disabled = true
    button_pick.visible = true
    button_end.visible = false
    # レーンをリセットする
    for i: int in lanes.get_child_count():
        var lane: Lane = lanes.get_child(i)
        lane.pickable = false
        lane.picked = false
        lane.target = false


func _refresh_roll_lamps() -> void:
    for i: int in roll_lamps.get_child_count():
        var lamp: Control = roll_lamps.get_child(i)
        lamp.modulate = Color.WHITE if i < roll else Color.WEB_GRAY
        lamp.visible = i < roll_max


func _refresh_pick_lamps() -> void:
    for i: int in pick_lamps.get_child_count():
        var lamp: Control = pick_lamps.get_child(i)
        lamp.modulate = Color.GREEN if i < pick else Color.WEB_GRAY
        lamp.visible = i < pick_max


func _reset_lanes() -> void:
    for i: int in lanes.get_child_count():
        var lane: Lane = lanes.get_child(i)
        lane.numbers = LANE_NUMBERS[i]
        lane.add = LANE_ADD[i]
        lane.score = 1
        lane.pickable = false
        lane.picked = false
        lane.target = false


func _get_temp() -> int:
    var t := 1
    for i: int in lanes.get_child_count():
        var lane: Lane = lanes.get_child(i)
        t *= lane.score
    return t


func _get_lane_index(dice_sum: int) -> int:
    var lane_index := 0
    for index: int in LANE_NUMBERS:
        var numers: Array = LANE_NUMBERS[index]
        if dice_sum in numers:
            lane_index = index
            break
    return lane_index
