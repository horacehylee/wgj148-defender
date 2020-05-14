extends Node2D

const COLOR_R = Color("df3e23")
const COLOR_B = Color("20d6c7")

const TYPE_R = 0
const TYPE_B = 1

const LAYER_WALL = 0
const LAYER_EARTH = 1
const LAYER_PADDLE_R = 2
const LAYER_PADDLE_B = 3
const LAYER_ENEMY_R = 4
const LAYER_ENEMY_B = 5
const LAYER_BULLET_R = 6
const LAYER_BULLET_B = 7

const GROUP_BULLETS = "bullets"
const GROUP_EARTH = "earth"
const GROUP_PADDLES = "paddles"
const GROUP_ENEMIES = "enemies"

onready var camera = $"/root/Node2D/Camera2D"
onready var screen_shake = camera.get_node("ScreenShake")

func _ready():
	print(screen_shake.name)
	randomize()
	
var dead = false
var win = false

func restart():
	dead = false
	win = false
	get_tree().reload_current_scene()
	
func shake(duration = 0.2, frequency = 15, amplitude = 16, priority = 0):
	screen_shake.start(duration, frequency, amplitude, priority)
