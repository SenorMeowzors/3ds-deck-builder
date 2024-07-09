extends Node3D

@onready var UI = $UI

# Called when the node enters the scene tree for the first time.
func _process(_delta):
	if Input.is_action_just_pressed("Pause"):
		UI.pauseMenu()
