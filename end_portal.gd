extends Node3D

signal entered()
var player
# Called when the node enters the scene tree for the first time.
func look():
	if player:
		look_at(player.position)
		rotation.y = 0

func _process(delta):
	if player:
		player.objTarget = global_position
		player.objActive = true

func _on_area_3d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.has_method("player"):
		emit_signal("entered")
