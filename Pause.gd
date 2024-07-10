extends Node3D

@onready var UI = $UI
var endPortal = preload("res://end_portal.tscn")
# Called when the node enters the scene tree for the first time.


func _process(_delta):
	if Input.is_action_just_pressed("Pause"):
		UI.pauseMenu()

func spawnEnd(x, y, z):
	var portal = endPortal.instantiate()
	portal.position = Vector3(x, y , z)
	portal.entered.connect(start_next_lvl)
	add_child(portal)

func start_next_lvl():
	get_node("/root/GlobalVars").saveDeck($PC.deck)
	get_node("/root/GlobalVars").first = false
	get_tree().change_scene_to_file("res://node_3d.tscn")
