extends Node3D

@export var textures: Array[CompressedTexture2D] = []

@onready var decal: Decal = $Decal

func _ready() -> void:
	var rand_index: int = randi_range(0, textures.size() - 1)
	var rand_size: float = randf_range(0.25, 1.0)
	var t = textures[rand_index]
	
	decal.rotation.y = randf_range(deg_to_rad(0.0), deg_to_rad(180.0))
	decal.texture_albedo = t
	decal.scale = Vector3(rand_size,rand_size,decal.size.z)
