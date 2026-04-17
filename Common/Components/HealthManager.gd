@icon("res://Assets/Icons/icon_heart.png")
extends Node
class_name HealthManager

signal damage_taken(amount)
signal no_health

@export var max_health: float = 100.0
var current_health: float


func _ready() -> void:
	current_health = max_health


func take_damage(amount: float):
	current_health -= amount
	damage_taken.emit(amount)
	if current_health <= 0.0:
		no_health.emit()
