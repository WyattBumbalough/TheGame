@icon("res://Assets/Icons/icon_path_follow.png")
class_name MovementComponent
extends Node

@export var body: CharacterBody3D
@export var nav_agent: NavigationAgent3D
@export var speed: float = 2.5

var direction: Vector3 = Vector3.ZERO
var time: float = 0.0

func update(_delta: float) -> void:
	if !body:
		printerr("No character body assigned to this movement component.")
		return
	
	body.velocity.x = direction.x * speed
	body.velocity.z = direction.z * speed
	body.move_and_slide()


func navigate_to(_position: Vector3, _delta: float, _delay: float = 0.1):
	if time >= _delay:
		nav_agent.target_position = _position
		time = 0.0
	else:
		time += _delta

	direction = body.global_position.direction_to(nav_agent.get_next_path_position())
	
	body.look_at(nav_agent.target_position)
	
	body.velocity.x = direction.x * speed
	body.velocity.z = direction.z * speed
	body.move_and_slide()
	
