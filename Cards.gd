extends Control

@onready var PC = get_parent().get_parent().PC
var reloading = false

func _process(_delta):
	$lCard.set_texture(null)
	if !PC.leftHand:
		return
	$lCard.set_texture(PC.leftHand.sprite)
	$rCard.set_texture(null)
	if !PC.rightHand:
		return
	$rCard.set_texture(PC.rightHand.sprite)

func PCreload():
	reloading = true

func PCreD():
	reloading = false
