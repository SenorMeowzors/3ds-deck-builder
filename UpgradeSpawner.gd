extends Node3D

var cards = [load("res://dash_card.tscn"), load("res://charge_proj_card.tscn"), load("res://heal_card.tscn"), load("res://slow_proj_card.tscn")]
var template = load("res://card_pickup.tscn")
@onready var UI = $"../UI"
var cloCard

func spawnUpgrade(x, y, z):
	var cardType = randi_range(0, cards.size() - 1)
	var upgrade = template.instantiate()
	upgrade.heldcard = cards[cardType]
	upgrade.position = Vector3(x, y + 0.5, z)
	get_parent().add_child(upgrade)
	upgrade.inRange.connect(cardInRange)
	upgrade.outRange.connect(cardOutRange)

func cardInRange(theCard, cardName):
	UI.pickup_in_range(cardName)
	cloCard = theCard

func cardOutRange():
	UI.pickup_left_range()
