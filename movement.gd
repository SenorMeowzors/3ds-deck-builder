extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 9
signal take_dmg
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var projectile = preload("res://projectile.tscn")
@onready var cameraf = $fpv
@onready var global = get_node("/root/GlobalVars")
var deck = Array()
var hasDashed = false
var objTarget = Vector3.ZERO
var objActive = false
var canShoot = true
func _ready():
	if !get_node("/root/GlobalVars").first:
		deck = get_node("/root/GlobalVars").deck
		deck.shuffle()

func _process(_delta):
	if !get_node("../UI").isPaused:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	if objActive:
		$rotater/objPointer.set_visible(true)
		$rotater/objPointer.look_at(objTarget)
	else:
		$rotater/objPointer.set_visible(false)
	if not is_on_floor():
		if hasDashed:
			velocity.y -= gravity * delta * 3
		velocity.y -= gravity * delta
	else:
		hasDashed = false
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var input_dir = Input.get_vector("left", "right", "forward", "backwards")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if !$MoveNoise.playing:
			$MoveNoise.play()
		if abs(velocity.x) < SPEED:
			velocity.x = direction.x * SPEED
		if abs(velocity.z) < SPEED:
			velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()
	if Input.is_action_pressed("shoot") and !get_node("../UI").isPaused and canShoot:
		attack(projectile)
		canShoot = false
		$shootTimer.start(.5)
	
	if Input.is_action_just_pressed("use_card") and !get_node("../UI").isPaused:
		useCard()
		deck.append(deck[0])
		deck.remove_at(0)
		
	if Input.is_action_just_pressed("cycle_card") and !get_node("../UI").isPaused:
		deck.append(deck[0])
		deck.remove_at(0)
	if velocity.y > JUMP_VELOCITY:
		hasDashed = true
	if abs(velocity.x) > SPEED or abs(velocity.z) > SPEED or velocity.y > JUMP_VELOCITY:
		velocity /= 1.1
func _input(event):
	if event is InputEventMouseMotion and !get_node("../UI").isPaused:
		rotation.y -= (event.relative.x * global.sens) / 100
		cameraf.rotation.x -= (event.relative.y * global.sens) / 250
		$rotater.rotation.x -= (event.relative.y * global.sens) / 250
		
func attack(Projectile: PackedScene) -> void:
	$ShootNoise.play()
	var atk = Projectile.instantiate()
	atk.position = position
	atk.set_dir(-cameraf.get_global_transform().basis.z, true)
	atk.maker = self
	get_parent().add_child(atk)
	

func removeCard():
	deck.remove_at(0)

func addCard(Card, Pickup):
	if deck.size() < 4:
		deck.append(Card.instantiate())
	else:
		deck.append(Card.instantiate())
	Pickup.queue_free()

func _on_hp_on_death():
	get_tree().change_scene_to_file("res://node_3d.tscn")

func useCard():
	if deck.size() == 0:
		return
	if !deck[0]:
		return
	if deck[0].has_method("use"):
		deck[0].use(self)
			
func _on_hp_take_dmg():
	$DmgNoise.play()
	take_dmg.emit()

func getHPNode():
	return $HP

func player():
	pass

func _on_shoot_timer_timeout():
	canShoot = true # Replace with function body.
