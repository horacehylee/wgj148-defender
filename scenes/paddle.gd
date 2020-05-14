extends KinematicBody2D

export(Array, Texture) var textures
export var type_index = 0

onready var global = $"/root/global"
onready var sprite = $"Sprite"

func init(type_index):
	self.type_index = type_index

func _ready():
	sprite.texture = textures[type_index]
	_set_collision()

func _set_collision():
	if type_index == global.TYPE_R:
		set_collision_layer_bit(global.LAYER_PADDLE_R, true)
		
		set_collision_mask_bit(global.LAYER_BULLET_R, true)
		set_collision_mask_bit(global.LAYER_ENEMY_R, true)
	elif type_index == global.TYPE_B:
		set_collision_layer_bit(global.LAYER_PADDLE_B, true)
		
		set_collision_mask_bit(global.LAYER_BULLET_B, true)
		set_collision_mask_bit(global.LAYER_ENEMY_B, true)
