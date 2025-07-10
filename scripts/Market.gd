extends Node
class_name Market

signal market_changed(new_market_row: Array[CardData])
signal game_over

var market_deck: Array[CardData] = []
var market_row: Array[CardData] = []
const MARKET_ROW_SIZE = 6

# Constructor
func _init(all_market_cards: Array[CardData]):
	self.market_deck = all_market_cards.duplicate()
	self.market_deck.shuffle()
	self.name = "Market"

# Called when the node is ready
func _ready():
	# This is intentionally left blank to prevent race conditions.
	# Initialization is handled by initialize_market().
	pass

func initialize_market():
	deal_initial_market()
	print_market_row()

func deal_initial_market():
	var num_to_deal = min(MARKET_ROW_SIZE, market_deck.size())
	for i in range(num_to_deal):
		deal_card_to_row()
	market_changed.emit(market_row)

func deal_card_to_row():
	if not market_deck.is_empty():
		var card = market_deck.pop_front()
		market_row.append(card)
	else:
		print("Market deck is empty! Game over condition triggered.")
		game_over.emit()

# Called by a player to buy a card. Returns the purchased card.
func purchase_card(card_index: int) -> CardData:
	if card_index < 0 or card_index >= market_row.size():
		print("Error: Invalid market index.")
		return null
	
	var card_to_buy = market_row[card_index]
	
	# Remove card from market and replace it
	market_row.remove_at(card_index)
	deal_card_to_row()
	
	market_changed.emit(market_row)
	print("Market updated.")
	print_market_row()
	
	return card_to_buy

func print_market_row():
	print("--- Market ---")
	for i in range(market_row.size()):
		var card = market_row[i]
		if card:
			print("[%d] %s (Cost: %d)" % [i, card.card_name, card.cost])
	print("--------------")
