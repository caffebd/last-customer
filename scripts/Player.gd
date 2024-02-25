extends CharacterBody3D


const WALK_SPEED:float = 1.25
const RUN_SPEED: float = 3.5
const JUMP_VELOCITY: float = 3.0

var moving_speed: float

#const SENSITIVITY:float = 0.003
const SENSITIVITY:float = 0.0008

var code_check_pos: int = 0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

#@onready var head = %Head
@onready var camera = %PlayerCam
@onready var ray = %PlayerRay
@onready var hud = %Hud
@onready var player_hand = %Hand

var door_opening_a: bool = false

var use_cursor: bool = false

var in_hand:String=""

var crowbar_hand = preload("res://scenes/CrowbarHand.tscn")
var fuse_hand = preload("res://scenes/FuseHand.tscn")



var note_a_text = "\n         [?] 8 3 5"
var note_b_text = "[u][b][i]You[/i][/b][/u] should [u][b][i]have[/i][/b][/u] taken the stairs [u][b][i]my[/i][/b][/u] [u][b][i]friend[/i][/b][/u]"

@export var test_mode: bool = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Signals.hand_item.connect(_set_hand_item)
	Signals.remove_item.connect(_remove_item)

	
	get_saved_inventory()


func _remove_item(item:String):
	_set_hand_item("Hand")
	hud.highlight_hand()
	hud.remove_from_inventory(item)


func _set_hand_item(item:String):
	print ("hand item "+item)
	if player_hand.get_child_count()>0:
		for the_item in player_hand.get_children():
			the_item.queue_free()
		#player_hand.get_child(0).queue_free()
	hud.note_display("")
	match item:
		"Hand":
			in_hand = item
			return
		"Crowbar":
			var in_hand_item = crowbar_hand.instantiate()
			player_hand.add_child(in_hand_item)
			in_hand = item
		"Fuse":
			var in_hand_item = crowbar_hand.instantiate()
			player_hand.add_child(in_hand_item)
			in_hand = item
							
func _input(event):
	if event is InputEventMouseMotion:
		if use_cursor:
			return
		rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60)) 
	if Input.is_action_just_pressed("ui_cancel"):
		if use_cursor:
			use_cursor = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			use_cursor = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_action_just_pressed("use"):
		_take_action()

	if Input.is_action_pressed("run"):
		moving_speed = RUN_SPEED
	else:
		moving_speed = WALK_SPEED
	
	if Input.is_action_just_released("inventory_up"):
		hud.inventory_up()
	if Input.is_action_just_released("inventory_down"):
		hud.inventory_down()
	
	
	if Input.is_action_just_pressed("to_menu"):
		_to_menu()
	
func _take_action():
	var collider = ray.get_collider()
	if collider != null and collider is StaticBody3D:
		if collider.has_method("use_action"):
			collider.use_action(in_hand)
		elif collider.is_in_group("collectible"):
			#hud.SaveState.saved_inventory.append(collider.item_name)
			collider.get_parent().queue_free()
			hud.add_to_inventory(collider.item_name)





func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var collider = ray.get_collider()
	hud.target.modulate = Color(1,1,1,0.2)

	%PlayerInfoLabel.visible = false
	if collider != null and collider is StaticBody3D:
		if collider.has_method("use_action") or collider.is_in_group("show_hud"):
			hud.target.modulate = Color(1,1,1,1)

			
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = lerp(velocity.x, direction.x * moving_speed, delta * 3.0)
			velocity.z = lerp(velocity.z, direction.z * moving_speed, delta * 3.0)
		else:
			velocity.x = lerp(velocity.x, direction.x * moving_speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * moving_speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * moving_speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * moving_speed, delta * 3.0)
	
	velocity.normalized()

	move_and_slide()


func get_saved_inventory():
	if SaveState.saved_inventory.size()==0:
		SaveState.saved_inventory.append("Hand")
		return
		print ("started empty inv")
	var all_collectibles = get_tree().get_nodes_in_group("collectible")
	for item in SaveState.saved_inventory:
		hud.add_to_inventory_from_load(item)
	for node in all_collectibles:
		if SaveState.saved_inventory.has(node.item_name):
			print ("removeig "+node.item_name)
			node.get_parent().queue_free()


func _to_menu():
	get_tree().change_scene_to_file("res://scenes/Menu.tscn")

func _on_fall_area_body_entered(body):
	if body.is_in_group("player"):
		%FallScream.play()
		var fall_timer = Timer.new()
		add_child(fall_timer)
		fall_timer.start(3);
		await fall_timer.timeout
		get_tree().change_scene_to_file("res://scenes/Menu.tscn")




