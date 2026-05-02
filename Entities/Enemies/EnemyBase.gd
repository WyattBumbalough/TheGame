class_name EnemyBaseClass
extends CharacterBody3D


@export var enemy_data: EnemyData

@export_group("Components")
@export var nav_agent: NavigationAgent3D
@export var movement_component: MovementComponent
@export var health_component: HealthManager
@export var hitbox_component: Hitbox
@export var sight_raycast: RayCast3D

var can_move: bool = true
var is_moving: bool = false

#var _nav_target_threshold: float = 2.0
var _nav_update_delay: float = 0.12
var time: float = 0.0

var _player: Player 
var player_detected: bool = false
var distance_to_player: float

var check_sight_delay: float = 0.15


func _ready() -> void:
	_setup()


func _setup():
	_player = Refs.PLAYER
	health_component.damage_taken.connect(_on_damage_taken)
	health_component.no_health.connect(_on_killed)
	sight_raycast.target_position = Vector3(0.0, 0.0, -enemy_data.detection_range)
	sight_raycast.enabled = false


func _physics_process(delta: float) -> void:
	if player_detected and can_move:
		# Wait a specified amount of frames before updating the navigation target position.
		#if time >= _nav_update_delay:
			#nav_agent.target_position = _player.global_position
			#time = 0.0
		#else:
			#time += delta
		#
		#var _dir: Vector3 = global_position.direction_to(nav_agent.get_next_path_position())
		#if _dir and can_move:
			#movement_component.direction = _dir
			#movement_component.update(delta)
			#is_moving = true
			#distance_to_player = global_position.distance_to(_player.global_position)
			#self.look_at(nav_agent.target_position)
			
			movement_component.navigate_to(_player.global_position, delta)
			
	else:
		_check_sight_to_player()


func _check_sight_to_player():
	sight_raycast.look_at(_player.global_position + Vector3.UP)
	sight_raycast.force_raycast_update()
	
	var collider = sight_raycast.get_collider()
	if collider and collider is Player:
		_on_player_detected()


func _attack(): 
	pass


func _on_player_detected():
	#player_detected = true
	#can_move = true
	pass


func _on_damage_taken(_amount: float, _position: Vector3, _normal: Vector3):
	if enemy_data.hitspark:
		var i = enemy_data.hitspark.instantiate()
		get_tree().get_root().add_child(i)
		i.global_position = _position
		i.look_at(_normal)


func _on_killed():
	pass
