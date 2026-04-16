extends PlayerState


func handle_physics(_delta) -> State:
	character.handle_movement(speed, accel, friction)
	
	var input_dir: Vector2 = character.input_direction
	if input_dir and character.allow_move:
		return walk_state
	
	return null
