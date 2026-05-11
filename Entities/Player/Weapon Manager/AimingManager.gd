class_name AimingManager extends Node

@export var weapon_manager: WeaponManager

var camera: Camera3D
var base_fov: float
var tween: Tween


func _ready() -> void:
	await get_tree().process_frame
	if weapon_manager:
		camera = weapon_manager.PLAYER.camera
		base_fov = camera.fov
	else:
		printerr("You forgot to connect the weapon manager to the aiming manager, dump ass.")


func zoom_camera_in():
	if !weapon_manager.cw:
		return
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(camera, "fov", base_fov - weapon_manager.cw.zoom_amount, 0.5)
	
func zoom_camera_out():
	if !weapon_manager.cw:
		return
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(camera, "fov", base_fov, 0.25)
