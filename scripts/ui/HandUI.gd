extends HBoxContainer
class_name HandUI

signal card_selected(card_index: int)

const CardUI = preload("res://scenes/ui/Card.tscn")

# Clears and redraws the hand with the provided cards
func display_cards(cards: Array[CardData]):
	# Clear existing card visuals
	for child in get_children():
		child.queue_free()
		
	# Instance a new CardUI for each card data
	for i in range(cards.size()):
		var card_data = cards[i]
		var card_visual = CardUI.instantiate()
		card_visual.card_data = card_data
		# Connect to the card's signal, passing the index as an argument
		card_visual.card_pressed.connect(_on_card_pressed.bind(i))
		add_child(card_visual)

func _on_card_pressed(card_index: int):
	card_selected.emit(card_index)
