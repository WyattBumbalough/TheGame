extends PlayerState
## Player death state.



func enter(_previous_state: State):
	PLAYER.allow_look = false
	PLAYER.cam_anims.play("Dead")


func exit(_next_state: State):
	pass


func handle_physics(_delta) -> State:
	PLAYER.handle_movement(speed, accel, friction)
	
	return null



func handle_input(_event: InputEvent) -> State:
	return null
