extends Node3D

signal entered()
# Called when the node enters the scene tree for the first time.

func _on_area_3d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.has_method("player"):
		emit_signal("entered")
