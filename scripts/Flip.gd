extends Node3D

var counter_open:bool = false

var is_blocked:bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func use_action(tool: String):
	if is_blocked or %CounterAnim.is_playing():
		return
	if counter_open:
		counter_open = false
		%CounterAnim.play("close_counter")
	else:
		counter_open = true
		%CounterAnim.play("open_counter")


func _on_check_area_body_entered(body):
	print (body.name)
	if body.is_in_group("player"):
		is_blocked = true


func _on_check_area_body_exited(body):
	print (body.name)
	if body.is_in_group("player"):
		is_blocked = false
