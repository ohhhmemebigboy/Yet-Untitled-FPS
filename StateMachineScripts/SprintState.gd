extends State
class_name SprintState

#head bob variables
const BOB_FREQUENCY = 1.5
const BOB_AMP = 0.14
var t_bob = 0.0

#headbobing calculation
func headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQUENCY) * BOB_AMP
	return pos

func enter(previous_state) -> void:
	Player.speed = 11.0

func update(delta):
	Player.update_gravity(delta)
	Player.update_input(delta)
	Player.update_velocity()
	
	if Input.is_action_pressed("sprint") == false and Player.is_on_floor():
		transition.emit("WalkingState")
	
	if Input.is_action_just_pressed("crouch") and Player.velocity.length() > 6:
		transition.emit("SlideState")
	
	if Input.is_action_just_pressed("jump") and Player.is_on_floor():
		transition.emit("JumpState")
	
	#head bob execution
	t_bob += delta * Player.velocity.length() * float(Player.is_on_floor())
	Player.camera.transform.origin = headbob(t_bob)
