class_name  EnemyRangedClass
extends EnemyBaseClass

@export var min_chase_time: float
@export var max_chase_time: float
@export var chase_timer: Timer

@export var projectile_spawner: ProjectileSpawner

var attacks_remaining: int

func _ready() -> void:
	super()
	chase_timer.timeout.connect(_on_chase_timer_ended)
	projectile_spawner.projectile_damage = enemy_data.attack_damage


func _physics_process(delta: float) -> void:
	super(delta)


func _aim():
	# Stop moving and stop looking for player.
	can_scan_for_player = false
	movement_component.stop_navigation()
	
	
	
	if enemy_data.aim_anim_name != "":
		AudioManager.play_sound_3d(global_position, enemy_data.aim_sound, 20.0)
		look_at(_player.global_position)
		visuals.play_animation(enemy_data.aim_anim_name, enemy_data.aim_anim_speed)


func _attack():
	attacks_remaining = randi_range(1, enemy_data.max_number_of_attacks)
	
	while attacks_remaining > 0:
		
		if enemy_data.attack_anim_name != "":
			await get_tree().create_timer(0.25).timeout
			look_at(_player.global_position)
			AudioManager.play_sound_3d(global_position, enemy_data.attack_sound, 20.0)
			
			visuals.stop_animation()
			visuals.play_animation(enemy_data.attack_anim_name)
			
			projectile_spawner.spawn(100.0)
			
			attacks_remaining -= 1


func _on_navigation_started():
	super()
	if chase_timer:
		chase_timer.start(randf_range(min_chase_time, max_chase_time))
	else:
		printerr("No chase timer detected.")


func _on_visual_anim_finished(_anim_name: String):
	if _anim_name == enemy_data.aim_anim_name:
		_attack()
	if _anim_name == enemy_data.attack_anim_name and attacks_remaining == 0:
		await get_tree().create_timer(enemy_data.attack_recovery_time).timeout
		can_scan_for_player = true
		movement_component.start_navigation()


func _on_player_detected():
	player_detected = true 
	can_move = true


func _on_chase_timer_ended():
	if _has_sight_to_player():
		_aim()
	else:
		chase_timer.start(randf_range(min_chase_time, max_chase_time))


func _on_killed():
	visuals.hide()
	_spawn_gibs(global_position)
	queue_free()
