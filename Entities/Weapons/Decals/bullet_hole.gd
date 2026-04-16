extends Node3D
class_name BulletHole

@export var despawn_time: float = 10.0


func _ready() -> void:
	await get_tree().create_timer(despawn_time).timeout
	queue_free()
