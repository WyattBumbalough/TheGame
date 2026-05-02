class_name EnemyMeleeClass
extends EnemyBaseClass

@export var hurtbox: Area3D


func _physics_process(delta: float) -> void:
	super(delta)
	if player_detected:
		if distance_to_player <= enemy_data.attack_range:
			_attack()


func _on_player_detected():
	player_detected = true
	can_move = true


func _attack():
	movement_component.stop_navigation()
	await get_tree().create_timer(enemy_data.attack_startup_time).timeout
	
	if hurtbox.get_overlapping_bodies().has(_player):
		_player.hitbox.take_damage(enemy_data.attack_damage)
		# For now this will only apply to the ghost enemy.
		hitbox_component.take_damage(enemy_data.attack_damage) 


func _on_damage_taken(_amount: float, _position: Vector3, _normal: Vector3):
	super(_amount, _position, _normal)


func _on_killed():
	queue_free()
