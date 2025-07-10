extends HBoxContainer
class_name PlayerStatsUI

signal end_turn_pressed

@onready var name_label: Label = $PlayerNameLabel
@onready var influence_label: Label = $InfluenceLabel
@onready var power_label: Label = $PowerLabel
@onready var end_turn_button: Button = $EndTurnButton

var current_influence: int = 0
var current_power: int = 0

const NORMAL_COLOR = Color("white")
const FLASH_COLOR_INFLUENCE = Color("cyan")
const FLASH_COLOR_POWER = Color("orangered")

func _ready():
	# Initialize with default values
	update_stats(0, 0)
	end_turn_button.pressed.connect(_on_end_turn_pressed)

func set_player_name(player_name: String):
	name_label.text = "%s's Turn" % player_name

func update_stats(new_influence: int, new_power: int):
	# Check for influence increase
	if new_influence > current_influence:
		flash_label(influence_label, FLASH_COLOR_INFLUENCE)
	
	# Check for power increase
	if new_power > current_power:
		flash_label(power_label, FLASH_COLOR_POWER)

	influence_label.text = "Influence: %d" % new_influence
	power_label.text = "Power: %d" % new_power
	
	current_influence = new_influence
	current_power = new_power

func flash_label(label: Label, flash_color: Color):
	# Ensure the property has a starting value before tweening
	if not label.has_theme_color_override("font_color"):
		label.add_theme_color_override("font_color", NORMAL_COLOR)

	# Create a tween to animate the color
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	# Set the color to the flash color immediately
	tween.tween_property(label, "theme_override_colors/font_color", flash_color, 0.0)
	# Transition back to the normal color over 0.8 seconds, after a 0.2s delay
	tween.tween_property(label, "theme_override_colors/font_color", NORMAL_COLOR, 0.8).set_delay(0.2)

func _on_end_turn_pressed():
	end_turn_pressed.emit()
