@icon("res://Assets/Icons/icon_hitbox.png")
extends Area3D
class_name Hitbox

@export var health_manager: HealthManager
@export var critical: bool = false


func take_damage(amount: float):
	if !health_manager:
		printerr("Health manager has not been configured.")
		return
	if health_manager.current_health <= 0.0:
		return
	
	health_manager.take_damage(amount)
	
	
	
