class_name  EnemyRangedClass
extends EnemyBaseClass

@export var min_chase_time: float
@export var max_chase_time: float
@export var chase_timer: Timer

@export var projectile_spawner: ProjectileSpawner

func _ready() -> void:
	super()
	chase_timer.timeout.connect(_on_chase_timer_ended)
	projectile_spawner.projectile_damage = enemy_data.attack_damage


func _physics_process(delta: float) -> void:
	super(delta)


func _aim():
	can_scan_for_player = false
	movement_component.stop_navigation()
	if enemy_data.aim_anim_name != "":
		AudioManager.play_sound_3d(global_position, enemy_data.aim_sound, 20.0)
		look_at(_player.global_position)
		visuals.play_animation(enemy_data.aim_anim_name, enemy_data.aim_anim_speed)


func _attack():
	await get_tree().create_timer(enemy_data.attack_startup_time).timeout
	if enemy_data.attack_anim_name != "":
		look_at(_player.global_position)
		AudioManager.play_sound_3d(global_position, enemy_data.attack_sound, 20.0)
		visuals.play_animation(enemy_data.attack_anim_name)
		projectile_spawner.spawn(100.0)


func _on_navigation_started():
	super()
	if chase_timer:
		chase_timer.start(randf_range(min_chase_time, max_chase_time))
	else:
		printerr("No chase timer detected.")


func _on_visual_anim_finished(_anim_name: String):
	if _anim_name == enemy_data.aim_anim_name:
		_attack()
	if _anim_name == enemy_data.attack_anim_name:
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
