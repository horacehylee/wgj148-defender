extends Area2D

const BULLET = preload("res://scenes/Bullet.tscn")
export(Array, Texture) var textures
export var speed = 5
export var bullet_spread_deg = 0
#export var fire_rate = 1
export var first_fire_delay = 1
export var next_fire_delay = 3

signal exploded()

const UP = Vector2(0, -1)

onready var global = $"/root/global"
onready var sprite = $"Sprite"
onready var bullet_spawner = $"BulletSpawner"
onready var bullet_timer = $"Timer"
onready var enemy_explosion = $"EnemyExplosion"

var rng = RandomNumberGenerator.new()
const target = Vector2(0, 0)
var type_index = 0

var dead = false

func init(type_index):
	self.type_index = type_index

func _ready():
	sprite.texture = textures[type_index]
	bullet_timer.start(first_fire_delay)
	rng.randomize()
	_set_collision()
	
func _physics_process(delta):
	if dead:
		return
	position = position.move_toward(target, speed * delta)
	rotation_degrees = rad2deg(UP.angle_to(target - position)) + 180
	
func _set_collision():
	if type_index == global.TYPE_R:
		set_collision_layer_bit(global.LAYER_ENEMY_R, true)
		
		set_collision_mask_bit(global.LAYER_BULLET_R, true)
	elif type_index == global.TYPE_B:
		set_collision_layer_bit(global.LAYER_ENEMY_B, true)
		
		set_collision_mask_bit(global.LAYER_BULLET_B, true)

func _on_Timer_timeout():
	if dead:
		return
#	return
	var bullet = BULLET.instance()
	var spread_sign = 1
	if rng.randf() < 0.5:
		spread_sign = -1
	var dir = (target - bullet_spawner.global_position).rotated(deg2rad(spread_sign * rng.randfn(0, 0.3) * bullet_spread_deg))
	bullet.init(type_index, dir)
	bullet.global_position = bullet_spawner.global_position
	get_parent().add_child(bullet)
	
	bullet_timer.start(next_fire_delay)

func _on_Enemy_body_entered(body: PhysicsBody2D):
	if dead:
		return
	if body.is_in_group(global.GROUP_BULLETS):
		body.hit_enemy()
		_explode()
	elif body.is_in_group(global.GROUP_EARTH):
		body.hit()
		_explode()
	elif body.is_in_group(global.GROUP_PADDLES):
		_explode()

func _explode():
	var color = global.COLOR_R
	if type_index == global.TYPE_B:
		color = global.COLOR_B
	enemy_explosion.modulate = color
	enemy_explosion.visible = true
	sprite.visible = false
	enemy_explosion.play()
	
	dead = true
	emit_signal("exploded")
	
	global.shake(0.2, 10, 1.2)

func _on_EnemyExplosion_animation_finished():
	queue_free()
