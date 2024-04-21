extends Area3D

@export var item_needed: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func use_action(item: String):
	if item_needed == item:
		Signals.emit_signal("place_item", item, self)
		print ("Place "+item)
