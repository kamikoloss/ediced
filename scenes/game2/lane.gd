class_name Lane
extends Control

var score := 0:
    set(v):
        score = v
        label_score.text = str(v)
var add := 0:
    set(v):
        add = v
        label_add.text = "+" + str(v)
var numbers := []:
    set(v):
        numbers = v
        label_number.text = "\n".join(v)

var pickable := false:
    set(v):
        pickable = v
        if v:
            lamp_pick.modulate = Color(Color.GREEN, 0.2)
        else:
            lamp_pick.modulate = Color.WEB_GRAY
var picked := false:
    set(v):
        picked = v
        if v:
            lamp_pick.modulate = Color.GREEN
        else:
            lamp_pick.modulate = Color.WEB_GRAY
var target := false:
    set(v):
        target = v
        if v:
            label_add.modulate = Color.BLUE
            lamp_add.modulate = Color.BLUE
        else:
            label_add.modulate = Color.WHITE
            lamp_add.modulate = Color.WEB_GRAY

@onready var label_score: Label = %LabelScore
@onready var label_add: Label = %LabelAdd
@onready var label_number: Label = %LabelNumber

@onready var lamp_add: Control = %LampAdd
@onready var lamp_pick: Control = %LampPick


func add_score() -> void:
    score += add
