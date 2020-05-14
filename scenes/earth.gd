extends StaticBody2D

export(Array, Color) var tints
export var max_health = 5
var health = max_health setget _set_health

signal hit()
signal dead()

onready var sprite = $"Sprite"

func hit():
	self.health -= 1
	global.shake(0.2, 20, 2, 1)
	
func _set_health(value):
	health = max(value, 0)
	sprite.self_modulate = tints[min(abs(health - max_health), tints.size() - 1)]
	if health <= 0:
		global.dead = true
