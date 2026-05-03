class_name EnemyBaseClass
extends CharacterBody3D

@export var enemy_data: EnemyData

@export_group("Components")
@export var visuals: EnemyVisuals
@export var nav_agent: NavigationAgent3D
@export var movement_component: MovementComponent
@export var health_component: HealthManager
@export var hitbox_component: Hitbox

var can_move: bool = true
var is_moving: bool = false

var time: float = 0.0

var _player: Player 
var player_detected: bool = false
var distance_to_player: float

var check_sight_delay: float = 0.75


func _ready() -> void:
	_setup()

func _setup():
	await get_tree().process_frame
	_player = Refs.PLAYER
	
	# Connect signals.
	health_component.damage_taken.connect(_on_damage_taken)
	health_component.no_health.connect(_on_killed)
	movement_component.on_navigation_started.connect(_on_navigation_started)
	
	if enemy_data.idle_anim_name != "":
		visuals.play_animation(enemy_data.idle_anim_name, enemy_data.idle_anim_speed)

func _physics_process(delta: float) -> void:
	if time >= check_sight_delay:
		if _has_sight_to_player():
			_on_player_detected()
		time = 0.0
	else:
		time += delta
	
	if _player:
		distance_to_player = self.global_position.distance_to(_player.global_position)
	
	if player_detected:
		await get_tree().create_timer(1.0).timeout
		movement_component.navigate_to(_player.global_position, delta)


func _has_sight_to_player() -> bool:
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var origin = global_position
	var end = _player.global_position + Vector3.UP
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_bodies = true
	
	var result = space_state.intersect_ray(query)
	if !result.is_empty():
		var collider = result.get("collider")
		if collider is Player:
			return true
		else:
			return false
	else:
		return false


func _spawn_hitspark(pos: Vector3, nor: Vector3):
	if enemy_data.hitspark != null:
		var instance = enemy_data.hitspark.instantiate()
		get_tree().get_root().add_child(instance)
		instance.global_position = pos
		instance.look_at(nor)
	else:
		printerr("No hitspark loaded for %s." %enemy_data.enemy_name)


func _attack(): 
	pass


func _on_player_detected():
	player_detected = true
	can_move = true


func _on_damage_taken(_amount: float, _position: Vector3, _normal: Vector3):
	pass


func _on_navigation_started():
	if enemy_data.move_anim_name != "":
		visuals.play_animation(enemy_data.move_anim_name, enemy_data.move_anim_speed)
	else:
		printerr("No move animation specified for %s." %enemy_data.enemy_name)


func _on_navigation_ended():
	if enemy_data.idle_anim_name != "":
		visuals.play_animation(enemy_data.idle_anim_name, enemy_data.idle_anim_speed)
	else:
		printerr("No idle animation specified for %s." %enemy_data.enemy_name)


func _on_killed():
	pass
