extends Node3D
class_name BloodHitEffect

@export var despawn_time: float = 10.0
@onready var sprite_3d: AnimatedSprite3D = $AnimatedSprite3D
@onready var parts: GPUParticles3D = $GPUParticles3D


func _ready() -> void:
	parts.emitting = true
	sprite_3d.rotation.z = randf_range(deg_to_rad(-90), deg_to_rad(90))
	await get_tree().create_timer(despawn_time).timeout
	queue_free()
