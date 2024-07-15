extends Control


@onready var PC = get_parent().get_parent().PC

func _process(_delta):
	$Card.set_texture(null)
	if PC.Atkdeck.size() <= 0:
		return
	$Card.set_texture(PC.Atkdeck[0].sprite)
	if PC.Specdeck.size() <= 0:
		$Card2.set_visible(false)
		return
	$Card2.set_visible(true)
	$Card2.set_texture(PC.Specdeck[1].sprite)
