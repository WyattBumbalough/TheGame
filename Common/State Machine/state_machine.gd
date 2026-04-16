extends Node
class_name StateMachine

@export var starting_state : State
var current_state : State
var previous_state : State

func initialize(_character : CharacterBody3D):
	for i in get_children():
		if i is State:
			i.character = _character
	change_state(starting_state)


func change_state(new_state: State):
	if current_state != null:
		current_state.exit(new_state)
	previous_state = current_state
	current_state = new_state
	current_state.enter(previous_state)


func handle_physics(delta):
	var new_state = current_state.handle_physics(delta)
	if new_state != null:
		change_state(new_state)


func handle_input(event: InputEvent):
	var new_state = current_state.handle_input(event)
	if new_state != null:
		change_state(new_state)
