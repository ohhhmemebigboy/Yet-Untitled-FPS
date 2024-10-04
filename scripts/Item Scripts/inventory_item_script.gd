extends Control

var invArrayIndex

@onready var texture = $TextureRect
@onready var area : Rect2


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func spawn(item_stats, i):
	texture.texture = item_stats.item_sprite
	self.position = Vector2(800,550)
	area.size = texture.size
	area.position = self.position
	invArrayIndex = i
	print(Global.inventory[invArrayIndex])
