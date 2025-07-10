extends Button
class_name SiteUI

signal site_selected(site_data: SiteData)

@export var site_data: SiteData:
	set(value):
		site_data = value
		if is_node_ready():
			update_display()
			if site_data:
				if not site_data.troops_changed.is_connected(on_troops_changed):
					site_data.troops_changed.connect(on_troops_changed)
				if not site_data.control_changed.is_connected(_on_control_changed):
					site_data.control_changed.connect(_on_control_changed)
	get:
		return site_data

@onready var name_label: Label = $MarginContainer/VBoxContainer/NameLabel
@onready var troops_label: Label = $MarginContainer/VBoxContainer/TroopsLabel
@onready var control_label: Label = $MarginContainer/VBoxContainer/ControlLabel

func _ready():
	self.pressed.connect(_on_pressed)
	update_display()
	if site_data:
		if not site_data.troops_changed.is_connected(on_troops_changed):
			site_data.troops_changed.connect(on_troops_changed)
		if not site_data.control_changed.is_connected(_on_control_changed):
			site_data.control_changed.connect(_on_control_changed)

func _on_pressed():
	if site_data:
		site_selected.emit(site_data)

func update_display():
	if site_data:
		name_label.text = site_data.site_name
		update_troops_display(site_data.get_troops())
		_on_control_changed(site_data.controlling_player)
	else:
		name_label.text = "Empty Site"
		troops_label.text = ""
		control_label.text = ""

func update_troops_display(troops: Dictionary):
	var text = "Troops: "
	if troops.is_empty():
		text += "None"
	else:
		var troop_strings = []
		for player in troops:
			troop_strings.append("%s: %d" % [player.player_name, troops[player]])
		text += ", ".join(troop_strings)
	troops_label.text = text

func on_troops_changed(new_troops: Dictionary):
	update_troops_display(new_troops)

func _on_control_changed(controller: Player):
	if controller:
		control_label.text = "Controlled by %s" % controller.player_name
	else:
		control_label.text = "Contested"
