#class_name Lane
extends Control

var number := 0:
    set(v):
        number = v
        label_number.text = str(v)
        _init_buttons()
var button_count := 0:
    # 2: 1, 3: 2, ... 6: 5, 7: 6, 8: 5, ... 12: 1 
    get:
        return 6 - absi(number - 7)

var score := 0:
    set(v):
        score = v
        label_score.text = str(v)

@onready var buttons: VBoxContainer = %Buttons

@onready var label_score: Label = %LabelScore
@onready var label_number: Label = %LabelNumber


func _ready() -> void:
    pass


## button をすべて OFF にする
func set_button_off() -> void:
    for i: int in buttons.get_child_count():
        var button: Button = buttons.get_child(i)
        button.disabled = true
        button.modulate = Color.WEB_GRAY


## button を amount 個 READY にする
func set_button_ready(amount: int) -> void:
    for i in amount:
        var button_index := button_count - 1 - i
        var button: Button = buttons.get_child(button_index)
        button.disabled = true
        button.modulate = Color(Color.RED, 0.4)


## number を元に button を初期化する
func _init_buttons() -> void:
    for i: int in buttons.get_child_count():
        if i < button_count:
            continue
        var button: Button = buttons.get_child(i)
        button.queue_free()
    set_button_off()
