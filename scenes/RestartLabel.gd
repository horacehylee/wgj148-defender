extends Label

var triggered = false

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !triggered && (global.dead or global.win):
		visible = true
		triggered = true
		get_tree().paused = true
		
func _input(event):
	if triggered && (global.dead or global.win) && Input.is_action_pressed("restart"):
		global.restart()
		get_tree().paused = false
