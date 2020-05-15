extends Node

export var num_spawners = 48

signal all_waves_completed()

const ENEMY_SPAWNER = preload("res://scenes/EnemySpawner.tscn")
const SPAWNER_START_ANGLE = -PI / 2

const WAVES = [
	{
		"time": 5,
		"spawns": [
			[0, 0]
		]
	},
	# 5
	{
		"time": 5,
		"spawns": [
			[12, 0],
			[36, 1]
		]
	},
	# 10
	{
		"time": 7,
		"delay": 0.5,
		"spawns": [
			[4, 0],
			[6, 0],
			[8, 0]
		]
	},
	# 17
	{
		"time": 7,
		"delay": 0.5,
		"spawns": [
			[26, 1],
			[28, 1],
			[30, 1]
		]
	},
	# 24
#	{
#		"time": 3,
#		"delay": 0.5,
#		"spawns": [
#			[14, 0],
#			[16, 0]
#		]
#	},
#	# 27
#	{
#		"time": 3,
#		"delay": 0.5,
#		"spawns": [
#			[0, 1],
#			[46, 1]
#		]
#	},
#	# 30
#	{
#		"time": 4,
#		"delay": 0.5,
#		"spawns": [
#			[8, 0],
#			[10, 0]
#		]
#	},
#	# 34
#	{
#		"time": 4,
#		"delay": 0.5,
#		"spawns": [
#			[26, 1],
#			[28, 1]
#		]
#	},
	# 38
	{
		"time": 8,
		"delay": 1,
		"spawns": [
			[36, 1],
			[0, 1],
			[24, 0],
			[12, 0]
		]
	},
	# 46
	{
		"time": 8,
		"delay": 1,
		"spawns": [
			[18, 0],
			[30, 0],
			[42, 1],
			[6, 1]
		]
	},
	# 56
	{
		"time": 8,
		"delay": 1,
		"spawns": [
			[26, 0],
			[28, 0],
			[30, 0],
			[32, 0]
		]
	},
	{
		"time": 8,
		"delay": 1,
		"spawns": [
			[22, 1],
			[20, 1],
			[18, 1],
			[16, 1]
		]
	},
	# 48
	{
		"time": 1,
		"delay": 0.01,
		"spawns": [
			[12, 0],
			[36, 1]
		]
	},
	{
		"time": 1,
		"delay": 0.01,
		"spawns": [
			[0, 1],
			[24, 0]
		]
	},
	# 48
	{
		"time": 1,
		"delay": 0.01,
		"spawns": [
			[12, 1],
			[36, 0]
		]
	},
	{
		"time": 1,
		"delay": 0.01,
		"spawns": [
			[0, 0],
			[24, 1]
		]
	}
	# 52 / 50
]

var enemy_spawners: Array = []
var wave = -1
var spawn_index = 0
var enemies
var time = 60

func _ready():
	_populate_spawners()
	_next_wave()
	
	$CanvasLayer/TimeLabel.text = str(time)

func _populate_spawners():
	var radius = abs($EnemySpawnerPosition.position.y)
	var angle_diff = 2 * PI / num_spawners
	var angle = SPAWNER_START_ANGLE
	for i in range(num_spawners):
		var pos = Vector2(radius * cos(angle), radius * sin(angle))
		_create_spawner(pos)
		angle += angle_diff

func _create_spawner(position):
	var spawner = ENEMY_SPAWNER.instance()
	spawner.position = position
	add_child(spawner)
	enemy_spawners.append(spawner)
	
#func _process(delta):
#	if get_tree().get_nodes_in_group(global.GROUP_ENEMIES).size() == 0:
#		_next_wave()

func _next_wave():
	wave += 1
	spawn_index = 1
	
	if wave == WAVES.size():
		print("all waves completed!")
		emit_signal("all_waves_completed")
		return
	
	var w = WAVES[wave]
	var spawns = w["spawns"]
	
	if !w.has("delay"):
		for spawn in spawns:
			_spawn_enemy(spawn)
	else:
		_spawn_enemy(spawns[0])
		$SpawnDelayTimer.start(w["delay"])
		
	$WaveTimer.start(w["time"])

func _on_WaveTimer_timeout():
	_next_wave()

func _on_SpawnDelayTimer_timeout():
	var w = WAVES[wave]
	var delay = w["delay"]
	var spawns = w["spawns"]
	
#	if spawn_index >= spawns.size():
#		return
	_spawn_enemy(spawns[spawn_index])
	spawn_index += 1
	if spawn_index != spawns.size():
		$SpawnDelayTimer.start(w["delay"])
	
func _spawn_enemy(spawn):
	var spawner_index = spawn[0]
	var type_index = spawn[1]
	enemy_spawners[spawner_index].spawn(type_index)


func _on_CountDownTimer_timeout():
	time -= 1
	time = max(time, 0)
	var time_str = str(time)
	if time < 10:
		time_str = "0" + str(time)
	$CanvasLayer/TimeLabel.text = time_str
	if time == 0:
		global.win = true
