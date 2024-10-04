extends Control


@onready var inventory_item = preload("res://scenes/inventory_item.tscn")
@onready var world_item = preload("res://scenes/test_item.tscn")
@onready var background = $Background
@onready var background2 = $EquipBackground
@onready var background3 = $StatsBackground


var item_held = null
var item_offset = Vector2()
var item_last_position = Vector2()
var inv_area = Rect2()


# Called when the node enters the scene tree for the first time.
func _ready():
	inv_area.position = background.position
	inv_area.size = background.size

func _process(delta):
	var cursor_pos = get_global_mouse_position()

	if Input.is_action_just_pressed("inv grab"):
		grab(cursor_pos)
	if Input.is_action_just_released("inv grab") and item_held != null:
		release(cursor_pos)
	if item_held != null:
		item_held.position = cursor_pos + item_offset
		item_held.position.x = clamp(item_held.position.x, 0, 1600 - item_held.texture.size.x)
		item_held.position.y = clamp(item_held.position.y, 0, 800 - item_held.texture.size.y)
		item_held.area.position = item_held.position


func grab(cursor_pos):
	for i in get_children():
		if i != background and i != background2 and i != background3:
			if i.area.has_point(cursor_pos) == true:
				var children_index_array = []
				item_held = i
				item_offset = i.position - cursor_pos
				self.move_child(i, 1)
				i.z_index = self.get_children().size()
				for c in get_children():
					if c != item_held:
						c.z_index = 0
				return


func release(cursor_pos):
	if inv_area.has_point(item_held.position) == false:
		var instance = world_item.instantiate()
		Player.add_sibling(instance)
		instance.item_stats = Global.inventory[item_held.invArrayIndex]
		instance.position = Player.position
		item_held.queue_free()
	item_held = null
