extends Control

const HandUI = preload("res://scenes/ui/Hand.tscn")
const MarketUI = preload("res://scenes/ui/Market.tscn")
const SiteUI = preload("res://scenes/ui/Site.tscn")
const PlayerStatsUI = preload("res://scenes/ui/PlayerStatsUI.tscn")

const NUM_PLAYERS = 4

# --- Game State ---
var players: Array[Player] = []
var market: Market
var game_board_sites: Array[SiteData] = []
var current_player_index: int = 0

# --- UI Nodes ---
var hand_ui: HandUI
var market_ui: MarketUI
var player_stats_ui: PlayerStatsUI

func _ready():
	print("--- Setting up Tyrants of the Underdark ---")
	_setup_game_logic()
	_setup_ui()
	_start_game()

func _setup_game_logic():
	# Load resources
	var noble = load("res://assets/cards/noble.tres")
	var soldier = load("res://assets/cards/soldier.tres")
	var priestess = load("res://assets/cards/priestess_of_lolth.tres")
	var house_guard = load("res://assets/cards/house_guard.tres")
	var menzoberranzan = load("res://assets/sites/menzoberranzan.tres")
	var gracklstugh = load("res://assets/sites/gracklstugh.tres")
	game_board_sites = [menzoberranzan, gracklstugh]
	
	# Create market
	var market_deck_list: Array[CardData] = [priestess, house_guard]
	market = Market.new(market_deck_list)
	add_child(market)

	# Create players based on settings from the menu
	for player_name in GameSettings.player_names:
		var starting_cards: Array[CardData] = []
		for j in range(7): starting_cards.append(noble)
		for j in range(3): starting_cards.append(soldier)
		var new_player = Player.new(player_name, starting_cards)
		players.append(new_player)
		add_child(new_player)

func _setup_ui():
	# Create main layout
	var margin_container = MarginContainer.new()
	margin_container.anchors_preset = PRESET_FULL_RECT
	margin_container.add_theme_constant_override("margin_left", 20)
	margin_container.add_theme_constant_override("margin_right", 20)
	margin_container.add_theme_constant_override("margin_top", 20)
	margin_container.add_theme_constant_override("margin_bottom", 20)
	add_child(margin_container)
	var main_vbox = VBoxContainer.new()
	main_vbox.add_theme_constant_override("separation", 20)
	margin_container.add_child(main_vbox)
	
	# Market UI
	market_ui = MarketUI.instantiate()
	main_vbox.add_child(market_ui)
	market.market_changed.connect(market_ui.display_cards)
	market.game_over.connect(_on_game_over)
	market_ui.card_selected.connect(_on_market_card_selected)
	
	# Game Board UI
	var game_board_ui = HBoxContainer.new()
	game_board_ui.size_flags_vertical = Control.SIZE_EXPAND_FILL
	game_board_ui.alignment = HBoxContainer.ALIGNMENT_CENTER
	game_board_ui.add_theme_constant_override("separation", 20)
	main_vbox.add_child(game_board_ui)
	
	for site_data in game_board_sites:
		var site_visual = SiteUI.instantiate()
		site_visual.site_data = site_data
		site_visual.site_selected.connect(_on_site_selected)
		game_board_ui.add_child(site_visual)

	# Player Info Area
	var player_area = HBoxContainer.new()
	player_area.alignment = HBoxContainer.ALIGNMENT_CENTER
	main_vbox.add_child(player_area)
	player_stats_ui = PlayerStatsUI.instantiate()
	player_area.add_child(player_stats_ui)
	player_stats_ui.end_turn_pressed.connect(_on_end_turn_pressed)

	# Hand UI
	hand_ui = HandUI.instantiate()
	main_vbox.add_child(hand_ui)
	hand_ui.card_selected.connect(_on_hand_card_selected)

func _start_game():
	market.initialize_market()
	_start_turn_for_player(0)

func _start_turn_for_player(player_index: int):
	current_player_index = player_index
	var current_player = players[current_player_index]
	print("\n--- Starting turn for %s ---" % current_player.player_name)

	# Connect UI signals to the current player
	player_stats_ui.set_player_name(current_player.player_name)
	current_player.hand_changed.connect(hand_ui.display_cards)
	current_player.stats_changed.connect(player_stats_ui.update_stats)
	
	# Initialize player state for the turn
	current_player.initialize_player()
	current_player.stats_changed.emit(current_player.influence, current_player.power)

func _end_turn_for_player(player_index: int):
	var player = players[player_index]
	# Disconnect signals to prevent UI updates from the wrong player
	player.hand_changed.disconnect(hand_ui.display_cards)
	player.stats_changed.disconnect(player_stats_ui.update_stats)
	player.end_turn()

# --- Signal Handlers ---
func _on_hand_card_selected(card_index: int):
	var current_player = players[current_player_index]
	current_player.play_card(card_index)

func _on_market_card_selected(card_index: int):
	var current_player = players[current_player_index]
	current_player.buy_card_from_market(market, card_index)

func _on_site_selected(site_data: SiteData):
	var current_player = players[current_player_index]
	current_player.deploy_troop(site_data)

func _on_end_turn_pressed():
	_end_turn_for_player(current_player_index)
	var next_player_index = (current_player_index + 1) % players.size()
	_start_turn_for_player(next_player_index)

func _on_game_over():
	print("\n--- GAME OVER ---")
	
	var final_scores = {}
	
	# Calculate scores
	for player in players:
		var score = 0
		# Score from cards
		var all_cards = player.deck.draw_pile + player.deck.hand + player.deck.discard_pile
		for card in all_cards:
			score += card.victory_points
		
		# Score from site control
		for site in game_board_sites:
			if site.controlling_player == player:
				score += site.victory_points
		
		final_scores[player.player_name] = score
	
	# Announce winner
	print("Final Scores:")
	var winner_name = ""
	var max_score = -1
	for player_name in final_scores:
		print("- %s: %d points" % [player_name, final_scores[player_name]])
		if final_scores[player_name] > max_score:
			max_score = final_scores[player_name]
			winner_name = player_name
			
	print("\n%s wins the game!" % winner_name)
	
	# Disable further interaction
	get_tree().paused = true
