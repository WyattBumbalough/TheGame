class_name CameraRecoil extends Node3D

@export var weapon_manager: WeaponManager

@export_category("Recoil Settings")
@export var recoil_amount: Vector3
@export var snap_amount: float
@export var speed: float

var current_rotation: Vector3
var target_rotation: Vector3


func _ready() -> void:
	weapon_manager.weapon_fired.connect(_add_recoil)


func _process(delta: float) -> void:
	if weapon_manager.cw != null:
		recoil_amount.x = weapon_manager.cw.camera_x_recoil
		recoil_amount.y = weapon_manager.cw.camera_y_recoil
	
	target_rotation = lerp(target_rotation, Vector3.ZERO, 1.5 * delta)
	current_rotation = lerp(current_rotation, target_rotation, snap_amount * delta)
	basis = Quaternion.from_euler(current_rotation)


func _add_recoil():
	if weapon_manager.cw.current_ammo != 0:
		target_rotation += Vector3(recoil_amount.x, randf_range(-recoil_amount.y, recoil_amount.x), 0.0)
		#print(weapon_manager.cw.current_ammo)
