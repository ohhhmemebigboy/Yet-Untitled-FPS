extends State
class_name JumpState

#@onready var Left : RayCast3D = $"../../head/Left"
#@onready var Right : RayCast3D = $"../../head/Right"
@onready var CrouchCheck = $"../../ShapeCast3D"

var JumpPower = 5.5

func enter(previous_state) -> void:
	if previous_state.name == "WallJumpState" or previous_state.name == "WallRunState":
		pass
	elif previous_state.name == "SlideState":
		Player.velocity.y += JumpPower
		Animator.stop()
		Animator.seek(0, true)
	else:
		Player.velocity.y += JumpPower
	Animator.pause()

#func physics_update(delta):
	#if Input.is_action_just_pressed("jump") and Left.is_colliding() == true:
		#transition.emit("WallJumpState")
	#elif Input.is_action_just_pressed("jump") and Right.is_colliding() == true:
		#transition.emit("WallJumpState")

func update(delta):
	Player.update_gravity(delta)
	Player.update_input(delta)
	Player.update_velocity()
	
	if Player.is_on_wall_only():
		transition.emit("WallRunState")
	
	if Input.is_action_pressed("crouch") and Player.velocity.length() > 6.0:
		transition.emit("SlideState")
	
	if Player.is_on_floor():
		transition.emit("IdleState")
