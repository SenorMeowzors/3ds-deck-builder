extends Node3D

@export var BobCurve: Curve
@export var heldcard = load("res://dash_card.tscn")
var grounded = false
var started = false
var midHeight
var Cycle100 = 0.25
# Called when the node enters the scene tree for the first time.
func _ready():
	var temp = heldcard.instantiate()
	midHeight = position.y
	$Sprite3D.set_texture(temp.sprite)
	$Sprite3D2.set_texture(temp.sprite)

func _on_area_3d_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	if (body.has_method("addCard")):
		body.addCard(heldcard, self)
func _process(delta):

	rotation.y += delta
	Cycle100 += delta * 30
	if grounded:
		if Cycle100 > 100:
			Cycle100 = 0.0
		if BobCurve and started:
			position.y = midHeight + (BobCurve.sample(Cycle100 / 100) * .15)
		else:
			while abs(position.y - (midHeight + (BobCurve.sample(Cycle100 / 100) * .15))) > .005:
				Cycle100 += delta
			started = true
	else:
		position.y -= delta * 2
		if $RayCast3D.is_colliding():
			grounded = true
			midHeight = position.y
			print(midHeight)
