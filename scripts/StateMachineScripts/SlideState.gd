extends State
class_name SlideState

var slideAngle : float = 0.09
var slideAnimSpeed = 4.0

@onready var crouchCheck : ShapeCast3D = $"../../ShapeCast3D"

func exit():
	Player.fov_change = 1.5

func enter(previous_state) -> void:
	Player.fov_change = 2.0
	Player.speed = 13.0
	Animator.speed_scale = 1.0
	Animator.play("Slide", -1.0, slideAnimSpeed)

func update(delta):
	Player.update_gravity(delta)
	Player.update_velocity()
	
	if Input.is_action_just_pressed("shoot"):
		Player.shoot()
	
	if Input.is_action_just_pressed("jump") and Player.is_on_floor():
		transition.emit("JumpState")

func finish():
	transition.emit("CrouchState")
