extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var gravity = 12


@export var enemy_stats: enemyStats

func _ready():
	enemy_stats.health = enemy_stats.max_health

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var input_dir = Vector3.ZERO
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
	
	if enemy_stats.health <= 0:
		queue_free()
