class_name  EnemyRangedClass
extends EnemyBaseClass


func _physics_process(delta: float) -> void:
	super(delta)
	

func _on_player_detected():
	player_detected = true
	can_move = true


func _attack():
	pass
