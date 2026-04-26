extends Node
class_name State

var character: CharacterBody3D

func enter(_previous_state: State):
	pass


func exit(_next_state: State):
	pass


func handle_physics(_delta) -> State:
	return null


func handle_input(_event: InputEvent) -> State:
	return null
