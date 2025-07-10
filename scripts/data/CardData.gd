extends Resource
class_name CardData

## The name of the card
@export var card_name: String = "Card Name"
## The descriptive text on the card
@export var card_text: String = "Card Description"
## The cost in Influence to acquire this card from the market
@export var cost: int = 0
## The Faction of the card (e.g., Drow, Dragon, Elemental, Demon)
@export var faction: String = "Neutral"

## --- Card Effects ---
## The amount of Influence this card provides when played
@export var influence: int = 0
## The amount of Power this card provides when played
@export var power: int = 0

## A unique key for any special action the card performs
## e.g., "assassinate_troop", "promote_card"
@export var special_action: String = ""
## Value associated with the special action, if any
@export var special_action_value: int = 0
## The number of victory points this card is worth at the end of the game
@export var victory_points: int = 0
