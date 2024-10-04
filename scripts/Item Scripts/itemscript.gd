extends Node3D

@export var item_stats : itemStats

var scene_path: String = "res://scenes/test_item.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	item_stats.name = "test item"
	item_stats.type = "test item"


func pickup_item():
	if Player:
		Global.add_item(item_stats)
		self.queue_free()
