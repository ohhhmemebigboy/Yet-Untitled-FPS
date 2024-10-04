extends State
class_name WalkingState

#head bob variables
const BOB_FREQUENCY = 1.2
const BOB_AMP = 0.14
var t_bob = 0.0

func enter(previous_state) -> void:
	Player.speed = 8.0

#headbobing calculation
func headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQUENCY) * BOB_AMP
	return pos

func update(delta):
	Player.update_gravity(delta)
	Player.update_input(delta)
	Player.update_velocity()
	
	if Input.is_action_pressed("crouch"):
		transition.emit("CrouchState")
	
	if Input.is_action_pressed("sprint") and Player.is_on_floor() and Player.velocity.length() > 0.0:
		transition.emit("SprintState")
	
	if Input.is_action_just_pressed("jump") and Player.is_on_floor():
		transition.emit("JumpState")
	
	if Player.direction == Vector3.ZERO:
		transition.emit("IdleState")
	
	#head bob execution
	t_bob += delta * Player.velocity.length() * float(Player.is_on_floor())
	Player.camera.transform.origin = headbob(t_bob)
