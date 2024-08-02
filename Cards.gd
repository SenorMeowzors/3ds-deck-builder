extends Control

@onready var PC = get_parent().get_parent().PC
var reloading = false

func _process(_delta):
	$Card.set_texture(null)
	if PC.deck.size() <= 0:
		return
	$Card.set_texture(PC.deck[0].sprite)
	if reloading:
		$Card.set_texture(preload("res://reload.png"))

func PCreload():
	reloading = true

func PCreD():
	reloading = false
