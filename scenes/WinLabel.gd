extends Label

var triggered = false

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !triggered && global.win:
		visible = true
		triggered = true
