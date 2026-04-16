extends PlayerState


func enter(_previous_state : State):
	character.tween_cam_fov_up()


func exit(_next_state: State):
	if _next_state == walk_state:
		character.tween_cam_fov_down()


func handle_physics(_delta) -> State:
	character.handle_movement(speed, accel, friction)
	
	return null


func handle_input(_event: InputEvent) -> State:
	if Input.is_action_just_released("sprint") or Input.get_vector("left","right","up","down") == Vector2.ZERO:
		return walk_state
	
	return null
