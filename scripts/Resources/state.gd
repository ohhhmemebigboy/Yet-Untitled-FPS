extends Node
class_name State

#creates signal for switching between states
signal transition(new_state_name: StringName)

var Animator : AnimationPlayer

func _ready():
	Animator = Player.Animator

#functions for calling in the state machine script
func enter(previous_state) -> void:
	pass

func exit() -> void:
	pass

func update(delta : float) -> void:
	pass

func physics_update(delta : float) -> void:
	pass

func transitionCheck(delta : float) -> void:
	pass
