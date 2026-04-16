extends CharacterBody3D

@onready var label: Label3D = $Label3D


func _physics_process(delta: float) -> void:
	label.text = str($HealthManager.current_health)
