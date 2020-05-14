extends Node2D

var drag_start_pos = Vector2(0, -1)
var drag_start_rot = 0
var rot_speed = 500
onready var target_rot = rotation_degrees

func _process(delta):
	rotation_degrees = _rotation_towards(rotation_degrees, target_rot, rot_speed * delta)

func _on_OrbitDetector_mouse_dragged(mouse_pos):
	var deg = rad2deg(drag_start_pos.angle_to(mouse_pos))
	target_rot = drag_start_rot + deg
	if target_rot >= 360:
		target_rot -= 360

func _on_OrbitDetector_mouse_drag_started(mouse_pos):
	drag_start_rot = rotation_degrees
	drag_start_pos = mouse_pos

func _rotation_towards(from, to, maxDelta):
	if from == to:
		return to

	# convert degrees to [0, 359]
	if from < 0:
		from += 360
	if to < 0:
		to += 360
	
	# use from as reference 0
	var from_ref = 0
	var to_ref = to - from
	if to_ref < 0:
		to_ref += 360
	
	var dest = 0
	if to_ref <= 180:
		# rotate clockwise
		if to_ref <= maxDelta:
			dest = to_ref
		else:
			dest = maxDelta
	else:
		# rotate anti-clockwise
		if to_ref >= 360 - maxDelta:
			dest = to_ref
		else:
			dest = 360 - maxDelta
	
	# revert reference using from
	dest += from
	
	# convert back to [-180, 180]
	if dest > 180:
		return dest - 360
	else:
		return dest
