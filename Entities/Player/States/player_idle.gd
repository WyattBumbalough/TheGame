extends PlayerState


func enter(_previous_state: State):
	PLAYER.cam_anims.play("WeaponIdle", 0.25)


func handle_physics(_delta) -> State:
	PLAYER.handle_movement(speed, accel, friction)
	
	var input_dir: Vector2 = PLAYER.input_direction
	if input_dir and PLAYER.allow_move:
		return walk_state
	
	return null
