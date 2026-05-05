extends EnemyVisuals

@export var projectile_spawn_point: Marker3D
@onready var projectile = preload("res://Common/Components/Projectile/projectile_scene.tscn")

func launch_projectile():
	var i = projectile.instantiate()
	get_tree().get_root().add_child(i)
	i.global_transform = global_transform
