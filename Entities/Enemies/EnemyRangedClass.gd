class_name  EnemyRangedClass
extends EnemyBaseClass


func _physics_process(delta: float) -> void:
	super(delta)
	

func _on_player_detected():
	player_detected = true
	can_move = true


func _aim():
	movement_component.stop_navigation()
	if enemy_data.aim_anim_name != "":
		#play sound
		visuals.play_animation(enemy_data.aim_anim_name, enemy_data.aim_anim_speed, 0.5)


func _attack():
	await get_tree().create_timer(enemy_data.attack_startup_time).timeout
	visuals.play_animation(enemy_data.attack_anim_name)


func _on_visual_anim_finished(_anim_name: String):
	if _anim_name == enemy_data.aim_anim_name:
		_attack()
