extends Control

@onready var player_count_spinbox: SpinBox = $MarginContainer/VBoxContainer/PlayerCount/SpinBox
@onready var names_container: VBoxContainer = $MarginContainer/VBoxContainer/PlayerNamesContainer
@onready var start_button: Button = $MarginContainer/VBoxContainer/StartButton

const PlayerNameInput = preload("res://scenes/ui/PlayerNameInput.tscn")

func _ready():
	start_button.pressed.connect(_on_start_game_pressed)
	player_count_spinbox.value_changed.connect(_on_player_count_changed)
	# Initial setup
	_on_player_count_changed(player_count_spinbox.value)

func _on_player_count_changed(value: int):
	# Clear old name inputs
	for child in names_container.get_children():
		child.queue_free()
	
	# Create new name inputs
	for i in range(value):
		var name_input = PlayerNameInput.instantiate()
		names_container.add_child(name_input)
		name_input.set_player_number(i + 1)

func _on_start_game_pressed():
	var names: Array[String] = []
	for child in names_container.get_children():
		names.append(child.get_player_name())
	
	# Save settings to the singleton
	GameSettings.set_names(names)
	
	# Change to the main game scene
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
