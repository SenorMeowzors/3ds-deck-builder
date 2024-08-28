extends Node3D

@onready var UI = $UI
var endPortal = preload("res://end_portal.tscn")
@export var ePLoc = Vector3(0, 2.5, 0)
@export var PC : player
# Called when the node enters the scene tree for the first time.

func _process(_delta):
	if Input.is_action_just_pressed("Pause"):
		
		UI.pauseMenu()

func spawnEnd():
	var portal = endPortal.instantiate()
	portal.position = ePLoc
	portal.entered.connect(start_next_lvl)
	portal.player = PC
	portal.look()
	add_child(portal)
	

func start_next_lvl():
	get_node("/root/GlobalVars").saveDeck(PC.deck)
	get_node("/root/GlobalVars").first = false
	get_tree().change_scene_to_file("res://Lvl2.tscn")
