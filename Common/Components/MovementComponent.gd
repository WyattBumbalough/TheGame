@icon("res://Assets/Icons/icon_path_follow.png")
class_name MovementComponent
extends Node

signal on_navigation_started
signal on_navigation_stopped

@export var body: CharacterBody3D
@export var nav_agent: NavigationAgent3D
@export var speed: float = 2.5

var direction: Vector3 = Vector3.ZERO
var time: float = 0.0

var can_move: bool = false
var is_moving: bool = false

func update(_delta: float) -> void:
	if can_move:
		direction = body.global_position.direction_to(nav_agent.get_next_path_position())
		
		if !is_moving:
			is_moving = true
			on_navigation_started.emit()
		
		# Stuff to smoothly rotate the model towards a direction.
		var rot_speed = 4.0
		var target_rot = direction.signed_angle_to(Vector3.MODEL_REAR, Vector3.DOWN)
		if abs(target_rot - body.rotation.y) > deg_to_rad(60):
			rot_speed = 20
		body.rotation.y = lerp_angle(body.rotation.y, target_rot, rot_speed * _delta)
		
		#body.look_at(nav_agent.target_position)
		body.velocity.x = direction.x * speed
		body.velocity.z = direction.z * speed
		body.move_and_slide()


func navigate_to(_position: Vector3, _delta: float, _delay: float = 0.1):
	if can_move == false:
		return
	
	# Use time to delay the re-calculation of the nav agent.
	if time >= _delay:
		nav_agent.target_position = _position
		time = 0.0
	else:
		time += _delta
	
	# Signal that navigation has started and set the current state to is_moving.
	if !is_moving:
		is_moving = true
		on_navigation_started.emit()
	
	# Apply movement.
	direction = body.global_position.direction_to(nav_agent.get_next_path_position())
	body.look_at(nav_agent.target_position)
	body.velocity.x = direction.x * speed
	body.velocity.z = direction.z * speed
	
	body.move_and_slide()


func set_nav_target(pos: Vector3):
	nav_agent.target_position = pos


func start_navigation():
	can_move = true
	#is_moving = true
	


func stop_navigation():
	can_move = false
	is_moving = false
	
	body.velocity.x = 0.0
	body.velocity.y = 0.0
	
	on_navigation_stopped.emit()
