extends Control

@onready var target: TextureRect = %target

var target_mode = "off"


var fuse_icon = preload("res://scenes/FuseIcon.tscn")

var crowbar_icon = preload("res://scenes/CrowbarIcon.tscn")


var inventory_index: int = 0

@onready var inventory_grid = %Inventory

#var SaveState.saved_inventory:Array[String]

# Called when the node enters the scene tree for the first time.
func _ready():
	_set_inventory_color(0)

func remove_from_inventory(item:String):
	if SaveState.saved_inventory.has(item):
		for child in inventory_grid.get_children():
			if child.name == item+"Icon":
				child.queue_free()
				SaveState.saved_inventory.remove_at(SaveState.saved_inventory.find(item,0))
		print (SaveState.saved_inventory)

func add_to_inventory(item:String):
	if not SaveState.saved_inventory.has(item):
		match item:

			"Fuse":
				var icon_scene = fuse_icon.instantiate()
				inventory_grid.add_child(icon_scene)
				SaveState.saved_inventory.append(item)

			"Crowbar":
				var icon_scene = crowbar_icon.instantiate()
				inventory_grid.add_child(icon_scene)
				SaveState.saved_inventory.append(item)
				Signals.emit_signal("tray_out", false)


func add_to_inventory_from_load(item: String):
	match item:

		"Fuse":
			var icon_scene = fuse_icon.instantiate()
			inventory_grid.add_child(icon_scene)

		"Crowbar":
			var icon_scene = crowbar_icon.instantiate()
			inventory_grid.add_child(icon_scene)




func set_target_mode(mode:String):
	if mode == target_mode:
		return
	target_mode = mode
	if target_mode=="off":
		target.modulate.a = 145.0
	elif target_mode == "interact":
		target.modulate.a = 255.0


func inventory_up():
	var size = inventory_grid.get_child_count()
	print ("size "+str(size))
	inventory_index += 1
	if inventory_index == size:
		inventory_index = 0
	
	print (SaveState.saved_inventory[inventory_index])
	_set_inventory_color(inventory_index)
	Signals.emit_signal("hand_item", SaveState.saved_inventory[inventory_index])
	print (SaveState.saved_inventory)		

func inventory_down():
	var size = inventory_grid.get_child_count()
	inventory_index -= 1	
	if inventory_index<0:
		inventory_index = size-1
	print (SaveState.saved_inventory[inventory_index])
	_set_inventory_color(inventory_index)
	Signals.emit_signal("hand_item", SaveState.saved_inventory[inventory_index])	


func highlight_hand():
	inventory_index = 0
	_set_inventory_color(inventory_index)

func _set_inventory_color(index:int):
	for i in inventory_grid.get_children():
		i.color = Color(1,1,1,0.15)
	inventory_grid.get_child(index).color = Color(1,1,1,1)


func note_display(note:String):
	if note=="":
		%NoteText.visible = false
		return
	%NoteText.text = note
	%NoteText.visible = true

func update_dialogue(sentence:String, player_speak:bool):
	if sentence != "":
		%Dialogue.text = sentence
		%Dialogue.visible = true
		if player_speak:
			%PlayerAvatar.visible = true
			%CallAvatar.visible = false
		else:
			%CallAvatar.visible = true
			%PlayerAvatar.visible = false
	else:
		%Dialogue.visible = false
		%PlayerAvatar.visible = false
		%CallAvatar.visible = false
