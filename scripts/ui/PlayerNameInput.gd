extends HBoxContainer

@onready var label: Label = $Label
@onready var line_edit: LineEdit = $LineEdit

func set_player_number(num: int):
	label.text = "Player %d Name:" % num
	line_edit.placeholder_text = "Player %d" % num

func get_player_name() -> String:
	if line_edit.text.is_empty():
		return line_edit.placeholder_text
	return line_edit.text
