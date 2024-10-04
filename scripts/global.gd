extends Node

var inventory = []

@onready var invItem = preload("res://scenes/inventory_item.tscn")


signal inventory_updated

func add_item(item):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i].name == item.name and item.stackable == true and item.type == inventory[i].type:
			inventory[i].quantity += item.quantity
			return true
		elif inventory[i] == null:
			inventory[i] = item
			var instance = invItem.instantiate()
			Player.inventoryUI.add_child(instance)
			instance.spawn(item, i)
			return true
	return false

func remove_item():
	inventory_updated.emit()

func increase_inventory_size():
	inventory_updated.emit()
