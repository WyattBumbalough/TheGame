@icon("res://Assets/Icons/icon_path_follow.png")
class_name MovementComponent
extends Node

@export var body: CharacterBody3D
@export var nav_agent: NavigationAgent3D
@export var speed: float = 2.5

var direction: Vector3 = Vector3.ZERO

func update(_delta: float) -> void:
	if !body:
		return
	
	body.velocity.x = direction.x * speed
	body.velocity.z = direction.y * speed
