class_name Lane
extends Control

var number := 0:
    set(v):
        number = v
        label_number.text = str(v)
var button_count := 0:
    # 2: 1, 3: 2, ... 6: 5, 7: 6, 8: 5, ... 12: 1 
    get:
        return 6 - absi(number - 7)

var score := 0:
    set(v):
        score = v
        label_score.text = str(v)

@onready var label_score: Label = %LabelScore
@onready var label_number: Label = %LabelNumber
