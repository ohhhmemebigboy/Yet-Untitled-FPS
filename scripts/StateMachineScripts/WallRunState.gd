extends State
class_name WallRunState

@onready var Left : RayCast3D = $"../../head/Left"
@onready var Right : RayCast3D = $"../../head/Right"

func enter(previous_state):
	Player.gravity = 6
	Player.velocity.y = 0
	Player.speed = 12

func exit():
	Player.gravity = 12

func update(delta):
	Player.update_gravity(delta)
	Player.update_input(delta)
	Player.update_velocity()
	
	if Input.is_action_just_pressed("jump") and Left.is_colliding() == true:
		transition.emit("WallJumpState")
	elif Input.is_action_just_pressed("jump") and Right.is_colliding() == true:
		transition.emit("WallJumpState")
	
	if Player.is_on_wall_only() != true:
		transition.emit("JumpState")
