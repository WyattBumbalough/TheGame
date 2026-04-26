class_name EnemyBase
extends CharacterBody3D

@export var enemy_data: EnemyData
@export var max_detection_range: float = 10.0

@export_category("Components")
#@export var state_machine: StateMachine
@export var nav_agent: NavigationAgent3D
@export var movement_component: MovementComponent
@export var health_component: HealthManager
@export var sight_raycast: RayCast3D

var can_move: bool = true
var is_moving: bool = false

var _nav_target_threshold: float = 2.0
var _nav_update_delay: float = 0.12
var time: float = 0.0

var _player: Player 
var player_detected: bool = false

var check_sight_delay: float = 0.15


func _ready() -> void:
	_setup()


func _setup():
	_player = Refs.PLAYER
	health_component.damage_taken.connect(_on_damage_taken)
	health_component.no_health.connect(_on_killed)
	
	sight_raycast.enabled = false
	sight_raycast.target_position.z = -max_detection_range
	
	# Allow one physics tick before changing nav agent properties to avoid weird errors.
	await get_tree().physics_frame
	nav_agent.path_desired_distance = _nav_target_threshold


func _physics_process(delta: float) -> void:
	if player_detected:
		# Wait a specified amount of frames before updating the navigation target position.
		if time >= _nav_update_delay:
			nav_agent.target_position = _player.global_position
		else:
			time += delta
		
		var _dir: Vector3 = nav_agent.get_next_path_position()
		if _dir and can_move:
			movement_component.direction = _dir
			movement_component.update(delta)
			is_moving = true
	else:
		_check_sight_to_player()


func _check_sight_to_player():
	sight_raycast.look_at(_player.global_position + Vector3.UP)
	sight_raycast.force_raycast_update()
	var collider = sight_raycast.get_collider()
	if collider and collider is Player:
		_on_player_detected()


func _on_player_detected():
	player_detected = true
	can_move = true


func _on_damage_taken(_amount: float):
	pass


func _on_killed():
	pass
