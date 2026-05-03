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

var can_move: bool = true
var is_moving: bool = false

func update(_delta: float) -> void:
	if !body:
		printerr("No character body assigned to this movement component.")
		return
	
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


func stop_navigation():
	can_move = false
	is_moving = false
	
	body.velocity.x = 0.0
	body.velocity.y = 0.0
	
	on_navigation_stopped.emit()
