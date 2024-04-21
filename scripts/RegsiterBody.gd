extends StaticBody3D


var current_item: String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.set_item.connect(_item_on_counter)


func _item_on_counter(item: String):
	current_item = item

func use_action(tool: String):
	if current_item != "":
		Signals.emit_signal("item_purchased")
		print ("purchased "+current_item)
		current_item = ""
		
