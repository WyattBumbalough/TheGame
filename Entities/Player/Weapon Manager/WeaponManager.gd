@icon("res://Assets/Icons/icon_sword.png")
extends Node3D
class_name WeaponManager

@export var weapon_resources: Array[WeaponData]
@export var starting_weapons: Array[WeaponSlot]
@export var infinite_ammo: bool = false

@export_group("Input mapping")
@export var shoot_input: String
@export var reload_input: String
@export var weapon_wheel_up_input: String
@export var weapon_wheel_down_input: String
@export var slot_1: String
@export var slot_2: String
@export var slot_3: String
@export var slot_4: String

@onready var right_hand: Node3D = %RightHand
@onready var left_hand: Node3D = $LeftHand
@onready var anims: AnimationPlayer = %AnimationPlayer

# Sub-managers
@onready var shoot_manager: ShootManager = $ShootManager
@onready var ammo_manager: AmmoManager = %AmmoManager
@onready var animations_manager: AnimManager = %AnimationsManager
@onready var reload_manager: ReloadManager = $ReloadManager

@onready var light_flash: OmniLight3D = %LightFlash


# Spawn objects
@onready var bullethole_decal: PackedScene = preload("res://Entities/Weapons/Decals/bullethole_decal.tscn")
@onready var bloodhit_effect: PackedScene = preload("res://Entities/Weapons/Decals/bloodhit.tscn")

var weapon_stack: Array[int] = [] # Weapons currently held by the player.
var weapon_list: Dictionary = {} # All weapons available in game. {weapon name, weapon_id = resource}

var cw: WeaponData = null # Current Weapon
var cw_model: Node3D = null # Current Weapon model
var weapon_index: int = 0

var can_change_weapons: bool = true
var can_use_weapon: bool = true

var tween: Tween


func _ready() -> void:
	_initialize()


func _process(_delta: float) -> void:
	# Only process inputs while the player currently holds a weapon and \
	# is not being blocked from using it by some other process.
	if cw != null and cw_model != null and can_use_weapon:
		_weapon_inputs()


func _initialize():
	# Load all weapon resources into the dictionary.
	for w in weapon_resources:
		weapon_list[w.weapon_id] = w
		
	# Step through the list, setting each weapon as current to access its properties.
	for i in weapon_list.keys():
		cw = weapon_list[i]
		
		# Search for the weapon slot with the cooresponding weapon ID.
		for slot in right_hand.get_children():
			if slot.weapon_id == cw.weapon_id:
				# Check if the weapon is in the starting weapons list, and add it to the weapon stack.
				for s_weapon in starting_weapons:
					if s_weapon.weapon_id == cw.weapon_id:
						weapon_stack.append(cw.weapon_id)
						
				cw.weapon_slot = slot
				cw_model = cw.weapon_slot.weapon_model
				cw_model.visible = false
	
	if weapon_stack.size() > 0:
		_enter_weapon(weapon_stack[0])


func _enter_weapon(next_weapon: int):
	cw = weapon_list[next_weapon]
	next_weapon = 0
	cw_model = cw.weapon_slot.weapon_model
	cw_model.visible = true
	
	if cw.equip_anim_name != "":
		anims.play(cw.equip_anim_name, -1, cw.equip_anim_speed)
	
	# Pass the current weapon and its model to all the sub-managers.
	shoot_manager.get_current_weapon(cw)
	animations_manager.get_current_weapon(cw, cw_model)
	reload_manager.get_current_weapon(cw)
	
	if cw.is_shooting: cw.is_shooting = false
	if cw.is_reloading: cw.is_reloading = false
	
	can_change_weapons = true
	can_use_weapon = true


func _exit_weapon(next_weapon: int):
	# Disable the weapon and lower it.
	if next_weapon != cw.weapon_id:
		can_change_weapons = false
		can_use_weapon = false
		
		cw_model.visible = false
		_enter_weapon(next_weapon)


func _change_weapon(next_weapon: int):
	if can_change_weapons and not cw.is_shooting and not cw.is_reloading:
		_exit_weapon(next_weapon)
	else:
		push_error("Can't change weapons right now.")
		return


func spawn_bullethole_decal(_pos: Vector3, _normal: Vector3):
	var instance: Node3D = bullethole_decal.instantiate()
	get_tree().get_root().add_child(instance)
	instance.global_position = _pos
	instance.look_at(instance.global_transform.origin + _normal)
	instance.rotate_object_local(Vector3.RIGHT, -PI/2)


func spawn_bloodhit_effect(_pos: Vector3, _normal: Vector3):
	var instance = bloodhit_effect.instantiate()
	get_tree().get_root().add_child(instance)
	instance.global_position = _pos
	instance.look_at(_normal)
	#instance.rotate_object_local(Vector3.RIGHT, -PI/2)


func spawn_muzzle_flash():
	if cw.muzzle_flash_ref != null:
		var instance = cw.muzzle_flash_ref.instantiate()
		add_child(instance)
		instance.global_position = cw.weapon_slot.barrel_point.global_position
		instance.emitting = true
	else:
		push_error("% does not have a muzzle flash setup." % cw.weapon_name)
	
	light_flash.light_energy = 2.5
	
	if tween: tween.kill()
	
	tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(light_flash, "light_energy", 0.0, 0.2)


func weapon_sound_player(sound_name: AudioStream, sound_speed: float):
	pass


func _weapon_inputs():
	if Input.is_action_just_pressed(shoot_input): shoot_manager.shoot()
	if Input.is_action_just_pressed(reload_input): reload_manager.reload()
	
	if Input.is_action_just_pressed(weapon_wheel_up_input):
		if can_change_weapons and !cw.is_reloading and !cw.is_shooting:
			weapon_index = min(weapon_index + 1, weapon_stack.size() - 1)
			_change_weapon(weapon_stack[weapon_index])
	
	if Input.is_action_just_pressed(weapon_wheel_down_input):
		if can_change_weapons and !cw.is_reloading and !cw.is_shooting:
			weapon_index = max(weapon_index - 1, 0)
			_change_weapon(weapon_stack[weapon_index])
	
	if Input.is_action_just_pressed(slot_1) and weapon_stack.size() > 0:
		weapon_index = 0
		_change_weapon(weapon_stack[weapon_index])
	if Input.is_action_just_pressed(slot_2) and weapon_stack.size() > 1:
		weapon_index = 1
		_change_weapon(weapon_stack[weapon_index])
	if Input.is_action_just_pressed(slot_3) and weapon_stack.size() > 2:
		weapon_index = 2
		_change_weapon(weapon_stack[weapon_index])
	if Input.is_action_just_pressed(slot_4) and weapon_stack.size() > 3:
		weapon_index = 3
		_change_weapon(weapon_stack[weapon_index])
