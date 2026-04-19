extends CharacterBody3D

@onready var label: Label3D = $Label3D
@onready var health_manager: HealthManager = $HealthManager


func _ready() -> void:
	health_manager.no_health.connect(queue_free)
	health_manager.damage_taken.connect(spawn_blood)


func _physics_process(_delta: float) -> void:
	label.text = str($HealthManager.current_health)


func spawn_blood(arg):
	pass
