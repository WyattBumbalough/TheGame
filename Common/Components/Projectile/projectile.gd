class_name Projectile extends RayCast3D


@export var speed: float = 50.0
@export var damage: float = 10.0

func _physics_process(delta: float) -> void:
	position += global_basis * Vector3.FORWARD * speed * delta
	target_position = Vector3.FORWARD * speed * delta
	force_raycast_update()
	
	var _collider = get_collider()
	var _point = get_collision_point()
	var _normal = get_collision_normal()
	
	if is_colliding():
		if _collider.has_method("take_damage"):
			_collider.take_damage(damage, _point, _normal )
		$mesh.hide()
		set_physics_process(false)


func cleanup():
	queue_free()


func _on_timer_timeout() -> void:
	queue_free()
