extends KinematicBody2D

export(Array, Texture) var textures

const UP = Vector2(0, -1)
const MAX_BOUNCES = 2

onready var global = $"/root/global"
onready var sprite = $"Sprite"
onready var timer = $"Timer"
onready var explosion = $"Explosion"

var type_index= 0
export var speed = 60
export var life_time = 10
var bounces = 0 setget _set_bounces
var velocity: Vector2 setget _set_velocity

var dead = false

func init(type_index, direction):
	self.type_index = type_index
	self.velocity = direction.normalized() * speed

func _ready():
	sprite.texture = textures[type_index]
	timer.start(life_time)
	_set_collision()

func _set_collision():
	if type_index == global.TYPE_R:
		set_collision_layer_bit(global.LAYER_BULLET_R, true)
		
		set_collision_mask_bit(global.LAYER_ENEMY_R, true)
		set_collision_mask_bit(global.LAYER_PADDLE_R, true)
	elif type_index == global.TYPE_B:
		set_collision_layer_bit(global.LAYER_BULLET_B, true)
		
		set_collision_mask_bit(global.LAYER_ENEMY_B, true)
		set_collision_mask_bit(global.LAYER_PADDLE_B, true)
	
func _physics_process(delta):
	if dead:
		return
	var collision = move_and_collide(velocity * delta)
	if collision != null:
		_collided(collision)
	
func _collided(collision: KinematicCollision2D):
	if dead:
		return
	var collider = collision.collider
	if collider.is_in_group("walls"):
		self.velocity = velocity.bounce(collision.normal)
		self.bounces += 1
	elif collider.is_in_group("paddles"):
		self.velocity = velocity.bounce(collision.normal)
	elif collider.is_in_group("earth"):
		collider.hit()
		_explode()
	
func hit_enemy():
	_explode()

func _set_velocity(value):
	rotation_degrees = rad2deg(UP.angle_to(value))
	velocity = value
	
func _set_bounces(value):
	bounces = value
	if bounces > MAX_BOUNCES:
		_explode()
		
func _explode():
	var color = global.COLOR_R
	if type_index == global.TYPE_B:
		color = global.COLOR_B
	explosion.modulate = color
	explosion.visible = true
	sprite.visible = false
	explosion.play()
	
	dead = true

func _on_Timer_timeout():
	_explode()

func _on_Explosion_animation_finished():
	queue_free()
