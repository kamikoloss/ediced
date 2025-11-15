extends Control

var score := 0:
    set(v):
        score = v
        label_score.text = str(v)
var target := 0:
    set(v):
        target = v
        label_target.text = str(v)

var phase := 0
var stage := 0
var reroll_count := 0:
    set(v):
        reroll_count = v
        _refresh_reroll_lamps()

var dice_numbers := [0, 0, 0]:
    set(v):
        dice_numbers = v
        label_dice_a.text = str(v[0])
        label_dice_b.text = str(v[1])
        label_dice_c.text = str(v[2])

@onready var lanes: Control = %Lanes
@onready var reroll_lamps: Control = %RerollLamps

@onready var button_roll: Button = %ButtonRoll
@onready var button_end: Button = %ButtonEnd

@onready var label_score: Label = %LabelScore
@onready var label_target: Label = %LabelTarget
@onready var label_phase: Label = %LabelPhase
@onready var label_stage: Label = %LabelStage
@onready var label_dice_a: Label = %LabelDiceA
@onready var label_dice_b: Label = %LabelDiceB
@onready var label_dice_c: Label = %LabelDiceC


func _ready() -> void:
    button_roll.pressed.connect(_on_button_roll_pressed)
    button_end.pressed.connect(_on_button_end_pressed)

    for i: int in lanes.get_child_count():
        var lane: Lane = lanes.get_child(i)
        lane.number = i + 2 # 0-9 -> 2-11
        lane.score = 1

    reroll_count = 3


func _on_button_roll_pressed() -> void:
    reroll_count -= 1
    if reroll_count == 0:
        button_roll.disabled = true
        button_end.disabled = true

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

    #var target_lane_index := dice_a + dice_b - 2 # 2-11 -> 0-9
    #var lane: Lane = lanes.get_child(target_lane_index)


func _on_button_end_pressed() -> void:
    phase += 1
    reroll_count = 3
    button_roll.disabled = false


func _refresh_reroll_lamps() -> void:
    for i: int in reroll_lamps.get_child_count():
        var lamp: Control = reroll_lamps.get_child(i)
        if i < reroll_count:
            lamp.modulate = Color.WHITE
        else:
            lamp.modulate = Color.WEB_GRAY
