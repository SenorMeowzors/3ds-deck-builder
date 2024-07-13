extends Control


@onready var PC = get_parent().get_parent().PC

func _process(_delta):
	$Card.set_texture(null)
	$Card/Uses.set_frame(15)
	if PC.deck.size() <= 0:
		return
	$Card.set_texture(PC.deck[0].sprite)
	$Card/Uses.set_frame(PC.deck[0].uses - 1)
	if PC.deck.size() <= 1:
		$Card2.set_visible(false)
		return
	$Card2.set_visible(true)
	$Card2.set_texture(PC.deck[1].sprite)
