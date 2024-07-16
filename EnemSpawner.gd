extends Node3D

@export var enemyList = [preload("res://Enemy.tscn"), preload("res://EnemyFly.tscn")]
@export var bossList = [preload("res://Boss.tscn")]
@onready var spawns = get_node("../Spawns").get_children()
@onready var upgradeSpawner = $"../UpgradeSpawner"
signal enemDeath
var deathsTillReward = 0
var deathsTillBoss = 10
var won = false
var bossSpawned = false
# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_enem()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func spawn_enem():
	var enem = enemyList[randi_range(0, enemyList.size() - 1)].instantiate()
	enem.position = spawns[(randi() % spawns.size())].position
	enem.target = $"../PC"
	enem.onDeath.connect(on_enem_death)
	add_child(enem)

func _on_timer_timeout():
	if won:
		return
	spawn_enem()

func on_enem_death(x, y, z):
	if deathsTillReward <= 1:
		upgradeSpawner.spawnUpgrade(x, y, z)
		deathsTillReward = 4
	else:
		deathsTillReward -= 1
	if deathsTillBoss <= 1 and !bossSpawned:
		spawn_boss()
		bossSpawned = true
	else:
		deathsTillBoss -= 1
	get_node("/root/GlobalVars").addScore(2)

func on_boss_death(x, y , z):
	upgradeSpawner.spawnUpgrade(x, y, z)
	won = true
	$"..".spawnEnd()
	get_node("/root/GlobalVars").addScore(10)

func spawn_boss():
	var enem = bossList[randi_range(0, bossList.size() - 1)].instantiate()
	enem.position = spawns[(randi() % spawns.size())].position
	enem.target = $"../PC"
	enem.onDeath.connect(on_boss_death)
	add_child(enem)
