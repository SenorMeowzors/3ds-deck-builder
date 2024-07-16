extends Node3D

@export var BobCurve: Curve
@export var heldcard = load("res://dash_card.tscn")
var grounded = false
var started = false
var midHeight
var Cycle100 = 0.0
signal inRange(cardName)
signal outRange

func _ready():
	var temp = heldcard.instantiate()
	midHeight = position.y
	$Sprite3D.set_texture(temp.sprite)
	$Sprite3D2.set_texture(temp.sprite)

func _on_area_3d_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	if (body.has_method("addCard")):
		inRange.emit(self, heldcard.instantiate().cardName)

func _on_area_3d_body_shape_exited(_body_rid, body, _body_shape_index, _local_shape_index):
	if (body.has_method("addCard")):
		outRange.emit()

func collect(player):
	player.addCard(heldcard, self, heldcard.instantiate().isAtk)
	

func _process(delta):
	rotation.y += delta
	Cycle100 += delta * 30
	if grounded:
		if Cycle100 > 100:
			Cycle100 = 0.0
		if BobCurve and started:
			position.y = midHeight + (BobCurve.sample(Cycle100 / 100) * .15)
		else:
			var kval = Cycle100
			var stay = true
			if position.y > midHeight + (BobCurve.sample(Cycle100 / 100) * .15):
				while stay:
					Cycle100 += .01
					if Cycle100 > 100:
						Cycle100 = 0.0
					if Cycle100 == kval:
						stay = false
					if position.y > midHeight + (BobCurve.sample(Cycle100 / 100) * .15):
						stay = false
			else:
				while stay:
					Cycle100 += .01
					if Cycle100 > 100:
						Cycle100 = 0.0
					if Cycle100 == kval:
						stay = false
					if position.y < midHeight + (BobCurve.sample(Cycle100 / 100) * .15):
						stay = false
			Cycle100 -= .01
			started = true
	else:
		position.y -= delta * 3
		if $RayCast3D.is_colliding():
			grounded = true
			midHeight = position.y


