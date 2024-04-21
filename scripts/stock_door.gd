extends StaticBody3D

var door_open = false

var hinge: Node3D

var door_moving: bool = false

var swing_dir = -100


# Called when the node enters the scene tree for the first time.
func _ready():
	hinge = get_parent()

	
	

func use_action(tool: String):
	operate_door()

func operate_door():
	if door_moving:
		return
	door_moving = true
	door_open = !door_open
	#$DoorCollision.disabled = true
	if door_open:
		var tween = create_tween()
		print (swing_dir)
		tween.tween_property(hinge, "rotation_degrees:y", swing_dir, 1.5)
		await tween.finished
		door_moving = false
		#$DoorCollision.disabled = false
	else:
		var tween = create_tween()
		tween.tween_property(hinge, "rotation_degrees:y", 0.0, 1.5)	
		await tween.finished
		door_moving = false
		#$DoorCollision.disabled = false




