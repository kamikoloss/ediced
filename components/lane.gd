class_name Lane
extends Control

var number := 0:
    set(v):
        number = v
        label_number.text = str(v)
        _init_buttons()
var score := 0:
    set(v):
        score = v
        label_score.text = str(v)

@onready var buttons: VBoxContainer = %Buttons

@onready var label_score: Label = %LabelScore
@onready var label_number: Label = %LabelNumber


func _ready() -> void:
    pass


## number を元に button を非表示にする
func _init_buttons() -> void:
    # 2: 1, 3: 2, ... 6: 5, 7: 6, 8: 5, ... 12: 1 
    var button_count := 6 - absi(number - 7)

    for i: int in buttons.get_child_count():
        var button: Button = buttons.get_child(i)
        button.visible = i < button_count
        button.disabled = true
        button.modulate = Color.WEB_GRAY
