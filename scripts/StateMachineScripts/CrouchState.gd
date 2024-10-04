extends State
class_name CrouchState

var crouchSpeed = 7.0

#head bob variables
const BOB_FREQUENCY = 1.2
const BOB_AMP = 0.14
var t_bob = 0.0

@onready var CrouchCheck : ShapeCast3D = $"../../ShapeCast3D"

#headbobing calculation
func headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQUENCY) * BOB_AMP
	return pos

func enter(previous_state):
	Player.speed = 3.0
	if previous_state.name != "SlideState":
		Animator.play("Crouch", -1.0, crouchSpeed)
	elif previous_state.name == "SlideState":
		Animator.current_animation = "Crouch"
		Animator.seek(1.0, true)

func update(delta):
	Player.update_gravity(delta)
	Player.update_input(delta)
	Player.update_velocity()
	
	#head bob execution
	t_bob += delta * Player.velocity.length() * float(Player.is_on_floor())
	Player.camera.transform.origin = headbob(t_bob)
	
	if Input.is_action_just_pressed("jump") and Player.is_on_floor():
		transition.emit("JumpState")
		uncrouch()
	
	if Input.is_action_pressed("crouch") == false:
		uncrouch()

#Code to ensure the player doesn't clip into the cieling when
#crouching under something
func uncrouch():
	if CrouchCheck.is_colliding() == false and Input.is_action_pressed("crouch") == false:
		Animator.play("Crouch", -1.0, -crouchSpeed * 1.5, true)
		if Animator.is_playing():
			await Animator.animation_finished
		transition.emit("IdleState")
	elif CrouchCheck.is_colliding() == true:
		await get_tree().create_timer(0.1).timeout
		uncrouch()
