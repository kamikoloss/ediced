extends Control

@onready var lanes: HBoxContainer = %Lanes

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
    pass
