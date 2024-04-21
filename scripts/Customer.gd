extends CharacterBody3D


var speed: float = 3.0
const JUMP_VELOCITY: float = 4.5

var leave_speed:float = 6.0

var angular_accelearation = 10

@export var markers: Array[Marker3D]

@export var counter_position: Marker3D
@export var player: CharacterBody3D

@export var shopping: Array[String]

@export var home_marker: Marker3D

var moving: bool = false

var at_counter: bool = false

var marker_index:int = 0

var can_walk: bool = false

var at_marker: bool = false

var going_home: bool = false


func _ready():
	#call_deferred("_next_marker")
	Signals.start_customer.connect(_start_walking)
	Signals.go_home.connect(_go_home)
	#%NavAgent.set_target_position(counter_position.global_position)


func _start_walking():
	_next_marker()

func _next_marker():

	%NavAgent.set_target_position(markers[marker_index].global_position)
	
	moving = true
	
		

func _move_towards(delta):
	var targetPos = %NavAgent.get_next_path_position()
	var direction = global_position.direction_to(targetPos)
	#faceDirection(direction)
	#faceDirection(targetPos)
	rotation.y=lerp_angle(rotation.y,atan2(-velocity.x,-velocity.z),.1)
	#look_at(targetPos)
	#rotation.y = lerp_angle(rotation.y, atan2(-velocity.x, -velocity.y), delta * angular_accelearation)
	velocity = direction * speed

	move_and_slide()

func faceDirection(direction : Vector3):
	
	look_at(Vector3(direction.x, global_position.y, direction.z), Vector3.UP)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	

	
	if moving:
		_move_towards(delta)
		if %NavAgent.is_navigation_finished():
			print ("DONE "+str(marker_index))
			moving = false
			if going_home:
				return
			if marker_index == markers.size()-1:
				at_counter = true
				Signals.emit_signal("set_basket", shopping)
			else:
				at_marker = true
				marker_index += 1

	
	if at_marker:
		var target_position = markers[marker_index].transform.origin
		var new_transform = transform.looking_at(target_position, Vector3.UP)
		transform  = transform.interpolate_with(new_transform, speed * delta)
		await get_tree().create_timer(3).timeout
		at_marker = false
		_next_marker()
		
	
	if at_counter:
		var target_position = player.transform.origin
		var new_transform = transform.looking_at(target_position, Vector3.UP)
		transform  = transform.interpolate_with(new_transform, speed * delta)

func _on_timer_timeout():
	moving = true


func _go_home():
	%NavAgent.set_target_position(home_marker.global_position)
	moving = true
	going_home = true
	at_counter = false
