extends Node
class_name StateMachine

@export var CURRENT_STATE : State
var states: Dictionary = {}

func _ready():
	#sets all possible states by cycling through all the child 
	#nodes of the state machine and adding them to the states
	#dictionary if they hace the state class script attached
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.transition.connect(on_child_transition)
		else:
			push_error("False State Error")
	CURRENT_STATE.enter(null)

#calls the process functions of the state scripts for the current state
func _process(delta):
	CURRENT_STATE.update(delta)
	#print(CURRENT_STATE.name)
func _physics_process(delta):
	CURRENT_STATE.physics_update(delta)

#function for transitioning from one state to another
func on_child_transition(new_state_name: StringName) -> void:
	var new_state = states.get(new_state_name)
	if new_state != null:
		if new_state != CURRENT_STATE:
			CURRENT_STATE.exit()
			new_state.enter(CURRENT_STATE)
			CURRENT_STATE = new_state
	else:
		push_warning("State Non-Existent")
