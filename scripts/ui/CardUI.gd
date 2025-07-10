extends Button
class_name CardUI

signal card_pressed

const FACTION_ART = {
	"Neutral": preload("res://assets/art/cards/neutral.svg"),
	"Drow": preload("res://assets/art/cards/drow.svg"),
	# Add other factions here as art is created
}

@export var card_data: CardData:
	set(value):
		card_data = value
		if is_node_ready():
			update_display()

@onready var name_label: Label = $MarginContainer/VBoxContainer/Header/NameLabel
@onready var cost_label: Label = $MarginContainer/VBoxContainer/Header/CostLabel
@onready var art_rect: TextureRect = $MarginContainer/VBoxContainer/ArtRect
@onready var text_label: Label = $MarginContainer/VBoxContainer/TextLabel

func _ready():
	self.pressed.connect(_on_pressed)
	update_display()

func _on_pressed():
	card_pressed.emit()

func update_display():
	if card_data:
		name_label.text = card_data.card_name
		cost_label.text = str(card_data.cost)
		text_label.text = card_data.card_text
		
		if FACTION_ART.has(card_data.faction):
			art_rect.texture = FACTION_ART[card_data.faction]
		else:
			art_rect.texture = FACTION_ART["Neutral"] # Default art
	else:
		name_label.text = "Empty"
		cost_label.text = ""
		text_label.text = ""
		art_rect.texture = null
