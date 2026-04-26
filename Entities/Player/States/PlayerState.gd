extends State
class_name PlayerState

@export_category("Movement")
@export var speed: float = 1.0
@export var accel: float = 0.05
@export var friction: float = 0.25

@export_category("Connecting States")
@export var idle_state: PlayerState
@export var walk_state: PlayerState
@export var run_state: PlayerState
@export var jump_state: PlayerState
@export var fall_state: PlayerState
@export var crouch_state: PlayerState
