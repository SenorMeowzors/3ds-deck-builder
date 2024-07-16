extends CharacterBody3D

var speed = 5.0
var jump_height = 9
signal take_dmg
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var cameraf = $fpv
@onready var global = get_node("/root/GlobalVars")
var Atkdeck = Array()
var Specdeck = Array()
var hasDashed = false
var objTarget = Vector3.ZERO
var objActive = false
var canShoot = true
var canSpec = true
var tilShufAtk = 0
var tilShufSpec = 0
func _ready():
	if !get_node("/root/GlobalVars").first:
		Atkdeck = get_node("/root/GlobalVars").Specdeck
		Atkdeck.shuffle()
		Specdeck = get_node("/root/GlobalVars").Specdeck
		Specdeck.shuffle()
	else:
		Atkdeck.append(preload("res://default_proj_card.tscn").instantiate())
		Atkdeck.append(preload("res://default_proj_card.tscn").instantiate())
		Atkdeck.append(preload("res://default_proj_card.tscn").instantiate())

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
		velocity.y = jump_height
	var input_dir = Input.get_vector("left", "right", "forward", "backwards")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if !$MoveNoise.playing:
			$MoveNoise.play()
		if abs(velocity.x) < speed:
			velocity.x = direction.x * speed
		if abs(velocity.z) < speed:
			velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	move_and_slide()
	if Input.is_action_pressed("use_atk") and !get_node("../UI").isPaused and canShoot:
		if Atkdeck.size() == 0:
			return
		if !Atkdeck[0]:
			return
		useCard(Atkdeck)
		canShoot = false
		Atkdeck.append(Atkdeck[0])
		Atkdeck.remove_at(0)
	
	if Input.is_action_just_pressed("cycle_card_atk") and !get_node("../UI").isPaused:
		Atkdeck.append(Atkdeck[0])
		Atkdeck.remove_at(0)
	
	if Input.is_action_just_pressed("use_spec") and !get_node("../UI").isPaused and canSpec:
		if Specdeck.size() == 0:
			return
		if !Specdeck[0]:
			return
		useCard(Specdeck)
		Specdeck.append(Specdeck[0])
		Specdeck.remove_at(0)
		canSpec = false
		$specTimer.start(0.5)
		
	if Input.is_action_just_pressed("cycle_card_spec") and !get_node("../UI").isPaused and Specdeck.size() > 0:
		Specdeck.append(Specdeck[0])
		Specdeck.remove_at(0)
		
	if Input.is_action_just_pressed("collect_card") and !get_node("../UI").isPaused:
		if $"../UpgradeSpawner".cloCard:
			$"../UpgradeSpawner".cloCard.collect(self)
			$"../UpgradeSpawner".cloCard = null

	if velocity.y > jump_height:
		hasDashed = true
	if abs(velocity.x) > speed or abs(velocity.z) > speed or velocity.y > jump_height:
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
	

func removeCard(deck):
	deck.remove_at(0)

func addCard(Card, Pickup, isAtk):
	if isAtk:
		Atkdeck.insert(randi_range(0, Atkdeck.size() - 1), Card.instantiate())
	else:
		Specdeck.insert(randi_range(0, Specdeck.size() - 1),Card.instantiate())
	Pickup.queue_free()

func _on_hp_on_death():
	get_tree().change_scene_to_file("res://node_3d.tscn")

func useCard(deck):
	var temp = deck[0]
	if deck == Atkdeck:
		tilShufAtk += 1
		$shootTimer.start(temp.recharge)
		if tilShufAtk > Atkdeck.size():
			Atkdeck.shuffle()
	else:
		tilShufSpec += 1
		$specTimer.start(temp.recharge)
		if tilShufSpec >= Specdeck.size():
			Specdeck.shuffle()
	if temp.has_method("use"):
		temp.use(self)
		if temp.fragile:
			removeCard(deck)
			temp.queue_free()
			
func _on_hp_take_dmg():
	$DmgNoise.play()
	take_dmg.emit()

func getHPNode():
	return $HP

func player():
	pass

func _on_shoot_timer_timeout():
	canShoot = true # Replace with function body.

func _on_spec_timer_timeout():
	canSpec = true # Replace with function body.

func take_slow(time):
	$slowTimer.start(time)
	speed /= 2

func _on_slow_timer_timeout():
	speed *= 2
