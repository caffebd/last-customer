extends StaticBody3D


@onready var fuse_label = %MissingFuse
@onready var fuse_inserted = %InsertedFuse
@export var the_fuse: Node3D
# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.need_fuse.connect(_fuse_label)
	if SaveState.fuse_inserted:
		insert_fuse()
		the_fuse.queue_free()

func _fuse_label(state):
	fuse_label.visible = state

func use_action(tool: String):
	if tool == "Fuse":
		print ("place fuse")
		Signals.emit_signal("remove_item","Fuse")
		insert_fuse()

func insert_fuse():
	print("INSERTING FUSE")
	fuse_inserted.visible = true
	SaveState.fuse_inserted = true
	fuse_label.text = "A fuse"
