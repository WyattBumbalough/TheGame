extends Node
class_name ShootManager

@export var weapon_manager: WeaponManager

@onready var ammo_manager: AmmoManager = %AmmoManager
@onready var animations_manager: AnimManager = %AnimationsManager

var cw: WeaponData # Current weapon
var collision_point: Vector3 = Vector3.ZERO
var rng: RandomNumberGenerator


func  get_current_weapon(_current_weapon):
	cw = _current_weapon


func shoot():
	if !cw.is_shooting and !cw.is_reloading and cw.current_ammo > 0:
		
		cw.is_shooting = true
		
		if cw.shoot_anim_name != "":
			Refs.PLAYER.crosshair.tween_crosshair()
			Refs.PLAYER.tween_cam_fov_up()
			weapon_manager.spawn_muzzle_flash()
			animations_manager.play_animation(cw.shoot_anim_name, cw.shoot_anim_speed)
			#sound.play(shoot)
		else:
			printerr("%s doesn't have a shoot animation." % cw.weapon_name)
			
		if !weapon_manager.infinite_ammo:
			cw.current_ammo -= 1
		# Number of projectiles fired at the same time. I.E. A shotgun shell will fire
		# 10+ pellets per shot. 
		for p in cw.projectiles_per_shot:
			hitscan()
	else:
		# Play empty sound
		print("Not enough ammo in mag.")
		
	cw.is_shooting = false


func hitscan():
	rng = RandomNumberGenerator.new()
	var spread = Vector3(rng.randf_range(cw.min_spread, cw.max_spread), rng.randf_range(cw.min_spread, cw.max_spread), rng.randf_range(cw.min_spread, cw.max_spread))
	
	var camera: Camera3D = Refs.PLAYER.camera
	var window: Window = get_window()
	var viewport: Vector2i
	var space_state: PhysicsDirectSpaceState3D = camera.get_world_3d().direct_space_state
	var screen_center: Vector2 = get_viewport().size / 2
	
	var origin: Vector3 = camera.project_ray_origin(screen_center)
	var end: Vector3 = origin + camera.project_ray_normal(screen_center) * 1000
	var query = PhysicsRayQueryParameters3D.create(origin, end + spread * 4)
	query.collide_with_areas = true
	query.collide_with_bodies = true
	
	var result: Dictionary = space_state.intersect_ray(query)
	
	if result:
		var collider = result.get("collider")
		var collider_point: Vector3 = result.get("position")
		var collider_normal: Vector3 = result.get("normal")
		var final_damage: float
		#print(collider_point)
		weapon_manager.spawn_bullethole_decal(collider_point, collider_normal)
		if collider is Hitbox:
			
			if collider.critical:
				Refs.PLAYER.crosshair.tween_hitmarker()
				final_damage = cw.weapon_damage * cw.headshot_damage_multiplier
				collider.take_damage(final_damage)
			else:
				final_damage = cw.weapon_damage
				collider.take_damage(final_damage)
		else:
			
			pass
