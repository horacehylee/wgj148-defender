extends Node2D

onready var outer_area = $"OuterArea"
onready var inner_area = $"InnerArea"

var pressed = false
var within_inner = false

signal mouse_dragged(mouse_pos)
signal mouse_drag_started(mouse_pos)

func _on_OuterArea_input_event(viewport, event, shape_idx):
	if within_inner:
		return
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		pressed = event.pressed
		if pressed:
			emit_signal("mouse_drag_started", get_local_mouse_position() + position)
	if event is InputEventMouseMotion:
		if pressed:
			emit_signal("mouse_dragged", get_local_mouse_position() + position)

func _on_OuterArea_mouse_exited():
	pressed = false

func _on_InnerArea_mouse_entered():
	within_inner = true
	pressed = false

func _on_InnerArea_mouse_exited():
	within_inner = false
	pressed = false
