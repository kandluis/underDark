extends Resource
class_name SiteData

signal troops_changed(new_troops: Dictionary)
signal control_changed(controller: Player)

## The name of the site (e.g., "Menzoberranzan")
@export var site_name: String = "Site Name"
## The total number of troop slots on this site
@export var capacity: int = 1
## The number of victory points this site is worth at the end of the game
@export var victory_points: int = 0
## A unique key for any special ability this site provides
@export var special_ability: String = ""
## An array of resource paths to neighboring sites
@export var neighbors: Array[String] = []

## --- Game State (will be modified during play) ---
var controlling_player: Player = null
var _troops: Dictionary = {}

func add_troop(player: Player):
	var current_troops = _troops.get(player, 0)
	_troops[player] = current_troops + 1
	troops_changed.emit(_troops)
	_update_control()

func get_troops() -> Dictionary:
	return _troops.duplicate()

func _update_control():
	var old_controller = controlling_player
	
	if _troops.is_empty():
		controlling_player = null
	else:
		var max_troops = 0
		var potential_controller = null
		var is_tied = false
		
		for player in _troops:
			var count = _troops[player]
			if count > max_troops:
				max_troops = count
				potential_controller = player
				is_tied = false
			elif count == max_troops:
				is_tied = true
		
		if is_tied:
			controlling_player = null
		else:
			controlling_player = potential_controller

	if old_controller != controlling_player:
		control_changed.emit(controlling_player)
