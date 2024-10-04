extends State
class_name IdleState



func update(delta):
	Player.update_gravity(delta)
	Player.update_input(delta)
	Player.update_velocity()
	
	if Input.is_action_pressed("crouch") and Player.is_on_floor():
		transition.emit("CrouchState")
	if Input.is_action_pressed("sprint") and Player.is_on_floor() and Player.velocity.length() > 0.0:
		transition.emit("SprintState")
	
	if Player.direction != Vector3.ZERO and Player.is_on_floor():
		transition.emit("WalkingState")
	
	if Input.is_action_just_pressed("jump") and Player.is_on_floor() and Player.inventoryUI.visible == false:
		transition.emit("JumpState")
