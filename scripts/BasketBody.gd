extends StaticBody3D

var basket_items: Array[String]

var current_item: String = ""

var item_counter: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	%Basket.visible = false
	%BasketColl.disabled = true
	Signals.set_basket.connect(_fill_basket)
	Signals.item_purchased.connect(_next_item)

func _fill_basket(items):
	%Basket.visible = true
	%BasketColl.disabled = false
	basket_items = items
	item_counter = 0
	current_item = basket_items[item_counter]

func _next_item():
	item_counter += 1
	if item_counter < basket_items.size():
		current_item = basket_items[item_counter]
	else:
		print ("basket empty")
		%Basket.visible = false
		%BasketColl.disabled = true
		Signals.emit_signal("go_home")

func use_action(tool: String):
	if current_item != "":
		Signals.emit_signal("set_item", current_item)
		print ("set "+current_item)
		current_item = ""
		
