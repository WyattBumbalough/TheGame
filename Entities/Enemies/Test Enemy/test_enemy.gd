extends CharacterBody3D

@onready var label: Label3D = $Label3D
@onready var health_manager: HealthManager = $HealthManager
@onready var ray_front: RayCast3D = %RayFront
@onready var rays: Node3D = %Rays

@onready var decal = preload("res://Entities/Weapons/Decals/blood_splat_small.tscn")


func _ready() -> void:
	health_manager.no_health.connect(queue_free)
	health_manager.damage_taken.connect(spawn_blood)


func _physics_process(_delta: float) -> void:
	label.text = str($HealthManager.current_health)


func spawn_blood(_arg):
	var player_pos = Refs.PLAYER.global_position
	rays.look_at(Vector3(player_pos.x, rays.global_position.y, player_pos.z))
	
	ray_front.force_raycast_update()
	
	if ray_front.is_colliding():
		var col_point = ray_front.get_collision_point()
		var col_normal = ray_front.get_collision_normal()
		var inst = decal.instantiate()
		get_tree().get_root().add_child(inst)
		inst.global_position = col_point
		inst.look_at(inst.global_transform.origin + col_normal)
		inst.rotate_object_local(Vector3.RIGHT, -PI/2)
	
	
