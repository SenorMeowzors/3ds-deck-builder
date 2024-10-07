extends card
var proj = preload("res://explosion.tscn")

func use(Player):
	var atk = proj.instantiate()
	atk.position = Player.position
	atk.position.y -= 0.5
	atk.maker = Player
	Player.get_parent().add_child(atk)
