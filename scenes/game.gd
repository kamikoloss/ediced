extends Control

var dice_a := 0:
    set(v):
        dice_a = v
        label_dice_a.text = str(v)
var dice_b := 0:
    set(v):
        dice_b = v
        label_dice_b.text = str(v)

@onready var lanes: HBoxContainer = %Lanes

@onready var button_roll: Button = %ButtonRoll
@onready var button_end: Button = %ButtonEnd

@onready var label_score: Label = %LabelScore
@onready var label_target: Label = %LabelTarget
@onready var label_phase: Label = %LabelPhase
@onready var label_stage: Label = %LabelStage
@onready var label_dice_a: Label = %LabelDiceA
@onready var label_dice_b: Label = %LabelDiceB

@onready var texture_rect_reroll_1: TextureRect = %TextureRectReroll1
@onready var texture_rect_reroll_2: TextureRect = %TextureRectReroll2
@onready var texture_rect_reroll_3: TextureRect = %TextureRectReroll3


func _ready() -> void:
    button_roll.pressed.connect(_on_button_roll_pressed)
    button_end.pressed.connect(_on_button_roll_pressed)


func _on_button_roll_pressed() -> void:
    var tween := create_tween()
    tween.set_loops(10)
    tween.parallel()
    tween.tween_callback(func() -> void: dice_a = randi_range(1, 6))
    tween.tween_callback(func() -> void: dice_b = randi_range(1, 6))
    tween.chain()
    tween.tween_interval(0.05)


func _on_button_end_pressed() -> void:
    pass
