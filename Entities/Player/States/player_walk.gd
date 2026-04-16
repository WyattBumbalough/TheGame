extends PlayerState


func handle_physics(_delta) -> State:
	character.handle_movement(speed, accel, friction)
	
	var input_dir: Vector2 = character.input_direction
	if input_dir:
		if Input.is_action_just_pressed(character.SPRINT) and character.allow_sprint:
			return run_state
	elif input_dir == Vector2.ZERO:
		return idle_state
	
	return null
