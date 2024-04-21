extends Node3D

var door_is_open: bool = false

var door_array: Array = []

var door_speed: float = 1.5

func _ready() -> void:
	Signals.main_doors.connect(_door_state)
	%DoorA.global_position.z = -9.616
	%DoorB.global_position.z = -15.11




func _door_state(state):
	if state == door_is_open:
		return
	door_is_open = state	
	if state:
		var tween = create_tween().set_parallel(true)
		tween.tween_property(%DoorA, "global_position:z", -6.2, door_speed)
		tween.tween_property(%DoorB, "global_position:z", -17.6, door_speed)
		#await get_tree().create_timer(5.0).timeout
		#_door_state(false)
	else:
		var tween = create_tween().set_parallel(true)
		tween.tween_property(%DoorA, "global_position:z", -9.616, door_speed)
		tween.tween_property(%DoorB, "global_position:z", -15.11, door_speed)


func _on_door_trigger_outside_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") or body.is_in_group("customer"):
		door_array.append(body)
		_door_state(true)




func _on_door_trigger_outside_body_exited(body: Node3D) -> void:
	if body.is_in_group("player") or body.is_in_group("customer"):
		var ind = door_array.find(body)
		if ind > -1:
			door_array.remove_at(ind)
		print (door_array)
		if door_array.size() == 0:
			_door_state(false)
