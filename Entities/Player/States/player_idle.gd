extends PlayerState


func enter(_previous_state: State):
	character.bob_anims.play("WeaponIdle", 0.25)


func handle_physics(_delta) -> State:
	character.handle_movement(speed, accel, friction)
	
	var input_dir: Vector2 = character.input_direction
	if input_dir and character.allow_move:
		return walk_state
	
	return null
