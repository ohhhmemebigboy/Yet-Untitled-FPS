extends Control

var paused = false

@onready var inventoryUI = $"../Inventory"
@onready var pauseMenu = $"."
@onready var HUD = $"../HUD"
@onready var crosshair = $"../HUD/Crosshair"

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		HUD.visible = true
		if inventoryUI.visible == true:
			inventoryUI.visible = false
		if paused == true:
			crosshair.visible = true
			pauseMenu.visible = false
			get_tree().paused = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		elif paused == false:
			crosshair.visible = false
			pauseMenu.visible = true
			get_tree().paused = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		paused = !paused
	
	if Input.is_action_just_pressed("inventory") and paused == false:
		inventoryUI.visible = !inventoryUI.visible
		HUD.visible = !HUD.visible
		if inventoryUI.visible == true:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if inventoryUI.visible == false:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_resume_pressed():
	pauseMenu.visible = false
	get_tree().paused = false
	crosshair.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	paused = !paused

func _on_quit_pressed():
	get_tree().quit()
