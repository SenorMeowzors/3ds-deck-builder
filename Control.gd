extends Control

@export var dmgCurve: Curve
@export var PC: Node
@onready var PCHP = PC.getHPNode()
@onready var blood = $"Fullscreen Effects/Blood"
@onready var globals = get_node("/root/GlobalVars")
@onready var HPBar = $"Fullscreen Effects/HPBar"
@onready var Health = $"Fullscreen Effects/HPBar/Health"
var isPaused = false
# Called when the node enters the scene tree for the first time.
var dmgVal = 0

func _ready():
	$PauseMenu.hide()
	$PauseMenu/VBoxContainer/opaLabel.set_text("Opacity - " + str(globals.opa * 100) + "%")
	$PauseMenu/VBoxContainer/sensLabel.set_text("Sensitivity - " + str(globals.sens * 100) + "%")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (blood):
		blood.self_modulate.a = dmgCurve.sample(1 - float(PCHP.hp)/PCHP.maxHP) * get_node("/root/GlobalVars").opa
	if HPBar:
		HPBar.size.x = float(PCHP.hp)/PCHP.maxHP * $"Fullscreen Effects/HPBar2".get_size().x
		if Health:
			Health.set_frame(PCHP.hp - 1)

func pauseMenu():
	if isPaused:
		Engine.time_scale = 1
		$PauseMenu.hide()
	else:
		Engine.time_scale = 0
		$PauseMenu.show()
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	isPaused = !isPaused

func _on_resume_pressed():
	pauseMenu()


func _on_quit_pressed():
	get_tree().quit()




func _on_opa_slider_value_changed(value):
	globals.opa = value
	$PauseMenu/VBoxContainer/opaLabel.set_text("Opacity - " + str(globals.opa * 100) + "%")


func _on_sens_slider_value_changed(value):
	globals.sens = value
	$PauseMenu/VBoxContainer/sensLabel.set_text("Sensitivity - " + str(globals.sens * 100) + "%")
