extends Node
class_name Player

signal hand_changed(new_hand: Array[CardData])
signal stats_changed(influence: int, power: int)

var player_name: String
var influence: int = 0:
	set(value):
		influence = value
		stats_changed.emit(influence, power)
var power: int = 0:
	set(value):
		power = value
		stats_changed.emit(influence, power)


var deck: Deck
var played_cards: Array[CardData] = []
var troops_in_barracks: int = 15 # Total troops available to deploy

# Constructor
func _init(p_name: String, starting_cards: Array[CardData]):
	self.player_name = p_name
	self.name = p_name # Set the node name for easy identification in the scene tree
	self.deck = Deck.new(starting_cards)

# Called when the node is ready
func _ready():
	# This is intentionally left blank to prevent race conditions.
	# Initialization is handled by initialize_player().
	pass

func initialize_player():
	print("%s has joined the game." % player_name)
	draw_starting_hand()

func draw_starting_hand(count: int = 5):
	deck.draw_cards(count)
	hand_changed.emit(deck.hand)
	print_hand()

func print_hand():
	print("%s's hand:" % player_name)
	for card in deck.hand:
		print("- %s" % card.card_name)

# Play a card from the hand by its index
func play_card(card_index: int):
	if card_index < 0 or card_index >= deck.hand.size():
		print("Error: Invalid card index.")
		return

	var card = deck.hand.pop_at(card_index)
	played_cards.append(card)
	
	# Add card's resources
	self.influence += card.influence
	self.power += card.power
	
	hand_changed.emit(deck.hand)
	print("%s played %s." % [player_name, card.card_name])
	print_current_resources()

# End the current turn
func end_turn():
	print("%s ends their turn." % player_name)
	# Move played cards and remaining hand to discard
	deck.discard_pile.append_array(played_cards)
	played_cards.clear()
	deck.discard_hand()
	
	# Reset turn resources
	self.influence = 0
	self.power = 0
	
	# Draw a new hand for the next turn
	deck.draw_cards(5)
	hand_changed.emit(deck.hand)
	print("--- New Turn ---")
	print_hand()

func print_current_resources():
	print("%s's resources: [Influence: %d, Power: %d]" % [player_name, influence, power])

# Attempt to buy a card from the market
func buy_card_from_market(market: Market, card_index: int):
	if market == null:
		print("Error: Market not found.")
		return

	if card_index < 0 or card_index >= market.market_row.size():
		print("Error: Invalid card index provided to player.")
		return
		
	var card_to_buy = market.market_row[card_index]
	
	if self.influence >= card_to_buy.cost:
		self.influence -= card_to_buy.cost
		var purchased_card = market.purchase_card(card_index)
		if purchased_card:
			deck.add_card_to_discard(purchased_card)
			print("%s bought %s." % [player_name, purchased_card.card_name])
			print_current_resources()
	else:
		print("%s cannot afford %s (Cost: %d, Influence: %d)." % [player_name, card_to_buy.card_name, card_to_buy.cost, self.influence])

# Deploy a troop to a target site
func deploy_troop(site: SiteData):
	if self.power < 1:
		print("Error: Not enough power to deploy a troop (cost: 1).")
		return
	
	if self.troops_in_barracks < 1:
		print("Error: No troops left in barracks.")
		return
		
	var current_troops_on_site = site.get_troops().get(self, 0)
	if (current_troops_on_site + 1) > site.capacity:
		print("Error: Site %s is at full capacity for this player." % site.site_name)
		return

	self.power -= 1
	self.troops_in_barracks -= 1
	site.add_troop(self)
	
	print("%s deployed a troop to %s." % [player_name, site.site_name])
	print_current_resources()
	print("Total troops on %s: %s" % [site.site_name, site.get_troops()])
