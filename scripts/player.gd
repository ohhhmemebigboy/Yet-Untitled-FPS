extends CharacterBody3D

var equipment = {
	"HEAD": itemStats,
	"CHEST": itemStats,
	"LEGS": itemStats,
	"BOOTS": itemStats,
	"MAIN HAND": itemStats,
	"OFF HAND": itemStats
	}

var speed = 8.0
var direction
var SENSITIVITY = 0.0025

var paused = false
var currentRotation : float

@export var player_stats : Player_Stats

@onready var test = preload("res://scenes/gun_test.tscn")

@onready var reloadTimer = $head/Camera3D/Weapons/Reload
@onready var ammoTotal = $HUD/AmmoTotal
@onready var ammoCurrent = $HUD/AmmoCurrent
@onready var healthCounter = $HUD/Health
@onready var camera = $head/Camera3D
@onready var head = $head
@onready var playerStateMachine = $StateMachine
@onready var slowMoMachine = $SlowMotionMachine
@onready var held_weapon = $head/Camera3D/Weapons
@onready var interact = $head/Camera3D/Interact
@onready var pickupUI = $"HUD/Pickup UI"
@onready var inventoryUI = $Inventory

@export var Animator : AnimationPlayer

#fov variables
const BASE_FOV = 75.0
var fov_change = 1.5

var gravity = 12

var ammoList = {
	"pistol ammo" = 60,
}

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	ammoCurrent.text = str(held_weapon.stats.current_mag)
	ammoTotal.text = str(ammoList[held_weapon.stats.ammo_type])
	player_stats.health = player_stats.max_health
	Global.inventory.resize(50)

func _unhandled_input(event):
	#camera look code
	if event is InputEventMouseMotion:
		currentRotation = -event.relative.y * SENSITIVITY
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(60))

func _physics_process(delta):
	#FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, 20)
	var target_fov = BASE_FOV + fov_change * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 6.0)
	healthCounter.text = str(player_stats.health)

#applies the gravity to the players y velocity; called in the
#state scripts
func update_gravity(delta) -> void:
	velocity.y -= gravity * delta

#compartmentalizes the move and slide function so it can be
#called in the state scripts
func update_velocity() -> void:
	move_and_slide()

func weirdWallFloorCheckThing() -> bool:
	if is_on_floor():
		return true
	if playerStateMachine.CURRENT_STATE.name == "WallRunState":
		return true
	return false

# Get the input direction and handle the movement/deceleration.
func update_input(delta) -> void:
	if Input.is_action_just_pressed("error check"):
		print(Global.inventory)
		print(inventoryUI.get_children())
	
	if Input.is_action_just_pressed("shoot") and held_weapon.stats.current_mag >  0 and inventoryUI.visible == false:
		shoot()
	
	if Input.is_action_just_pressed("reload") and ammoList[held_weapon.stats.ammo_type] > 0 and inventoryUI.visible == false:
		reload()
	
	if interact.is_colliding() and inventoryUI.visible == false:
		pickupUI.visible = true
	else:
		pickupUI.visible = false
	
	if Input.is_action_just_pressed("interact") and interact.is_colliding() and inventoryUI.visible == false:
		interact.get_collider().pickup_item()
	
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	if inventoryUI.visible == true:
		input_dir = Vector3.ZERO
	direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if weirdWallFloorCheckThing():
		if direction:
			velocity.x = lerp(velocity.x, direction.x * speed, 0.2)
			velocity.z = lerp(velocity.z, direction.z * speed, 0.2)
		else:
			velocity.x = move_toward(velocity.x, 0, 0.4)
			velocity.z = move_toward(velocity.z, 0, 0.4)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 2.0)

func shoot():
	var screen_center = get_viewport().size/2
	var space = camera.get_world_3d().direct_space_state
	var origin = camera.project_ray_origin(screen_center)
	var end = origin + camera.project_ray_normal(screen_center) * 10
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collision_mask = 2
	query.collide_with_bodies = true
	var hit = space.intersect_ray(query)
	if hit:
		hit.collider.enemy_stats.health -= player_stats.pistol_damage + player_stats.flat_damage_mod + player_stats.flat_pistol_damge_mod + (player_stats.pistol_damage * player_stats.per_damage_mod + player_stats.per_pistol_damge_mod)
		print(str(hit.collider.enemy_stats.health))
	held_weapon.stats.current_mag -= 1
	ammoCurrent.text = str(held_weapon.stats.current_mag)

func reload():
	ammoList[held_weapon.stats.ammo_type] = ammoList[held_weapon.stats.ammo_type] - held_weapon.stats.magazine_size + held_weapon.stats.current_mag
	held_weapon.stats.current_mag = held_weapon.stats.magazine_size
	if ammoList[held_weapon.stats.ammo_type] < 0:
		held_weapon.stats.current_mag += ammoList[held_weapon.stats.ammo_type]
		ammoList[held_weapon.stats.ammo_type] = 0
	ammoTotal.text = str(ammoList[held_weapon.stats.ammo_type])
	ammoCurrent.text = str(held_weapon.stats.current_mag)
