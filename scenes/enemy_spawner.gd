extends Position2D

const ENEMY = preload("res://scenes/Enemy.tscn")
const TARGET = Vector2()
const UP = Vector2(0, -1)
const spawn_delay = 3

export(Array, SpriteFrames) var sprites

var type_index

func _ready():
	rotation_degrees = rad2deg(UP.angle_to(TARGET - position)) + 180

func spawn(type_index):
	self.type_index = type_index
	$AnimatedSprite.frames = sprites[type_index]
	$AnimatedSprite.visible = true
	$AnimatedSprite.play()
	$Timer.start(spawn_delay)
	
func _on_Timer_timeout():
	var enemy = ENEMY.instance()
	enemy.init(type_index)
	enemy.global_position = global_position
	get_parent().add_child(enemy)
	
	$AnimatedSprite.stop()
	$AnimatedSprite.visible = false
