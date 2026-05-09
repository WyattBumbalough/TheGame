extends PlayerState


func enter(_previous_state: State):
	PLAYER.cam_anims.play("WeaponBob", 0.25, 2)


func handle_physics(_delta) -> State:
	PLAYER.handle_movement(speed, accel, friction)
	
	var input_dir: Vector2 = PLAYER.input_direction
	if input_dir:
		if Input.is_action_just_pressed(PLAYER.SPRINT) and PLAYER.allow_sprint:
			return run_state
	elif input_dir == Vector2.ZERO:
		return idle_state
	
	return null
