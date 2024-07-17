extends Control

@onready var PC = get_parent().get_parent().PC
var reloadingA = false
var reloadingS = false

func _process(_delta):
	$Card.set_texture(null)
	if PC.Atkdeck.size() <= 0:
		return
	$Card.set_texture(PC.Atkdeck[0].sprite)
	if reloadingA:
		$Card.set_texture(preload("res://reload.png"))
	if PC.Specdeck.size() <= 0:
		$Card2.set_visible(false)
		return
	$Card2.set_visible(true)
	$Card2.set_texture(PC.Specdeck[0].sprite)
	if reloadingS:
		$Card2.set_texture(preload("res://reload.png"))

func PCreloadA():
	reloadingA = true

func PCreloadS():
	reloadingS = true

func PCreAD():
	reloadingA = false

func PCreSD():
	reloadingS = false
