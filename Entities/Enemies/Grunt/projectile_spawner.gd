class_name ProjectileSpawner extends Marker3D


@export var _projectile: PackedScene
@export var projectile_damage: float


func spawn(_speed: float):
	if _projectile:
		var i = _projectile.instantiate()
		add_child(i)
		i.speed = _speed
		i.damage = projectile_damage
		i.global_transform = global_transform
	else:
		printerr("Projectile Spawner does not have a projectile scene defined.")
