class_name PlayerStateMachine extends StateMachine

func initialize(_character : CharacterBody3D):
	for i in get_children():
		i.PLAYER = _character
	change_state(starting_state)
