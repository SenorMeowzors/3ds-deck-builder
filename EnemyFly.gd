extends CharacterBody3D

var speed = 5.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
@export var target := Node3D
var targetPos = Vector3.ZERO
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var hp = 2
var canAttack = true
var projectile = preload("res://projectile.tscn")
@onready var atkCD = $AtkCooldown
signal onDeath(x, y, z)
func _physics_process(delta):
	# Add the gravity.
	var direction = Vector3.ZERO
	move_and_slide()
	if !target:
		return
	if position.distance_to(target.global_position) < 35:
		if position.distance_to(target.global_position) < 20:
			targetPos = Vector3(randi(), 0, randi())
		if canAttack:
			atkCD.start()
			attack(projectile)
			canAttack = false
	else:
		targetPos = target.global_position
	direction = (targetPos - global_position).normalized()
	if global_position.y < 10:
		direction.y += .5
	velocity = velocity.lerp(direction * speed, delta)
func attack(Projectile: PackedScene) -> void:
		var atk = Projectile.instantiate()
		atk.position = position
		atk.set_dir((target.position - position).normalized(), false)
		atk.maker = self
		get_parent().add_child(atk)
		
func _on_hp_on_death():
	onDeath.emit(position.x, position.y, position.z)
	queue_free() # Replace with function body.


func _on_atk_cooldown_timeout():
	canAttack = true # Replace with function body.
