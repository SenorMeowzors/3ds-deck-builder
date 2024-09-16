extends Node3D

@export var enemyList = [preload("res://EnemyGround.tscn"), preload("res://EnemyFly.tscn")]
@export var bossList = [preload("res://Boss.tscn")]
@export var spawn : Node
@export var currency = 3
@export var bossLvl = false
@export var survival = false
@export var prePlaced = false
@export var minEnems = 2
@onready var upgradeSpawner = $"../UpgradeSpawner"
signal enemDeath
var deathsTillReward = 0
var deathsTillBoss = 10
var won = false
var bossSpawned = false
@export var curEnems = 0
@onready var spawns = spawn.get_children()
# Called when the node enters the scene tree for the first time.
func _ready():
	if prePlaced:
		return
	while currency >= 0:
		spawn_enem()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func spawn_enem():
	var ran = randi_range(0, enemyList.size() - 1)
	if enemyList[ran].instantiate().cost > currency - minEnems + 1 + curEnems:
		return
	var enem = enemyList[ran].instantiate()
	enem.position = spawns[(randi() % spawns.size())].position
	enem.target = $"../PC"
	enem.onDeath.connect(on_enem_death)
	add_child(enem)
	curEnems += 1
	currency -= enem.cost
	

func _on_timer_timeout():
	if won:
		return
	spawn_enem()

func on_enem_death(pos : Vector3):
	curEnems -= 1
	if survival:
		if deathsTillReward <= 1:
			upgradeSpawner.spawnUpgrade(pos)
			deathsTillReward = 4
		else:
			deathsTillReward -= 1
		if deathsTillBoss <= 1 and !bossSpawned:
			spawn_boss()
			bossSpawned = true
		else:
			deathsTillBoss -= 1
		get_node("/root/GlobalVars").addScore(2)
		return
	if curEnems <= 0:
		upgradeSpawner.spawnUpgrade(pos)
		$"..".spawnEnd()

func on_boss_death(pos: Vector3):
	upgradeSpawner.spawnUpgrade(pos)
	won = true
	$"..".spawnEnd()
	get_node("/root/GlobalVars").addScore(10)

func spawn_boss():
	var enem = bossList[randi_range(0, bossList.size() - 1)].instantiate()
	enem.position = spawns[(randi() % spawns.size())].position
	enem.target = $"../PC"
	enem.onDeath.connect(on_boss_death)
	add_child(enem)
