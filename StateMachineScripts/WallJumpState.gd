extends State
class_name WallJumpState

@onready var Left : RayCast3D = $"../../head/Left"
@onready var Right : RayCast3D = $"../../head/Right"

var JumpPower : float = 5.5
var WallJumpPower : float = 3.5

func enter(previous_state) -> void:
	if Left.is_colliding() == true:
		Player.velocity += Left.get_collision_normal() * WallJumpPower
		Player.velocity.y += JumpPower
	if Right.is_colliding() == true:
		Player.velocity += Right.get_collision_normal() * WallJumpPower
		Player.velocity.y += JumpPower
	Animator.pause()

func update(delta):
	Player.update_gravity(delta)
	Player.update_input(delta)
	Player.update_velocity()
	
	transition.emit("JumpState")
