extends Node3D

@onready var particles_1: GPUParticles3D = $GPUParticles3D
@onready var particles_2: GPUParticles3D = $GPUParticles3D2


func _ready() -> void:
	particles_1.emitting = true
	particles_2.emitting = true
