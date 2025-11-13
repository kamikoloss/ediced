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

var dice_a := 0:
    set(v):
        dice_a = v
        label_dice_a.text = str(v)
var dice_b := 0:
    set(v):
        dice_b = v
        label_dice_b.text = str(v)

@onready var lanes: HBoxContainer = %Lanes
@onready var reroll_lamps: HBoxContainer = %RerollLamps

@onready var button_roll: Button = %ButtonRoll
@onready var button_end: Button = %ButtonEnd

@onready var label_score: Label = %LabelScore
@onready var label_target: Label = %LabelTarget
@onready var label_phase: Label = %LabelPhase
@onready var label_stage: Label = %LabelStage
@onready var label_dice_a: Label = %LabelDiceA
@onready var label_dice_b: Label = %LabelDiceB


func _ready() -> void:
    button_roll.pressed.connect(_on_button_roll_pressed)
    button_end.pressed.connect(_on_button_roll_pressed)

    for i: int in lanes.get_child_count():
        var lane: Lane = lanes.get_child(i)
        lane.number = i + 2 # 2-11
        lane.score = 1

    reroll_count = 3


func _on_button_roll_pressed() -> void:
    var tween := create_tween()
    tween.set_loops(10)
    tween.parallel()
    tween.tween_callback(func() -> void: dice_a = randi_range(1, 6))
    tween.tween_callback(func() -> void: dice_b = randi_range(1, 6))
    tween.chain()
    tween.tween_interval(0.05)
    await tween.finished

    reroll_count -= 1


func _on_button_end_pressed() -> void:
    pass


func _refresh_reroll_lamps() -> void:
    for i: int in reroll_lamps.get_child_count():
        var lamp: Control = reroll_lamps.get_child(i)
        if i < reroll_count:
            lamp.modulate = Color.WHITE
        else:
            lamp.modulate = Color.WEB_GRAY
