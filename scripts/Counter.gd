extends Node3D

var tape = preload("res://props/Tape.tscn")
var mask = preload("res://props/Mask.tscn")
var knife = preload("res://props/Knife.tscn")
# Called when the node enters the scene tree for the first time.

var counter_item:Node3D

func _ready():
	Signals.set_item.connect(_set_item)
	Signals.item_purchased.connect(_remove_item)

func _set_item(item):
	match item:
		"Tape":
			counter_item = tape.instantiate()
			add_child(counter_item)
			counter_item.global_position = %ItemMarker.global_position
		"Mask":
			counter_item = mask.instantiate()
			add_child(counter_item)
			counter_item.global_position = %ItemMarker.global_position
		"Knife":
			counter_item = knife.instantiate()
			add_child(counter_item)
			counter_item.global_position = %ItemMarker.global_position
			
func _remove_item():
	counter_item.queue_free()
	counter_item = null
