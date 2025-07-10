extends RefCounted
class_name Deck

var draw_pile: Array[CardData] = []
var hand: Array[CardData] = []
var discard_pile: Array[CardData] = []

# Constructor: Initialize the deck with a set of starting cards
func _init(starting_cards: Array[CardData]):
	draw_pile = starting_cards.duplicate()
	shuffle()

# Shuffle the draw pile
func shuffle():
	draw_pile.shuffle()

# Draw a number of cards from the draw pile to the hand
func draw_cards(count: int):
	for i in range(count):
		# If draw pile is empty, shuffle discard pile into it
		if draw_pile.is_empty():
			if discard_pile.is_empty():
				# No cards left to draw
				break
			draw_pile = discard_pile.duplicate()
			discard_pile.clear()
			shuffle()
		
		var card = draw_pile.pop_front()
		if card:
			hand.append(card)

# Move all cards from the hand to the discard pile
func discard_hand():
	discard_pile.append_array(hand)
	hand.clear()

# Add a new card to the discard pile (e.g., when buying from the market)
func add_card_to_discard(card: CardData):
	discard_pile.append(card)
