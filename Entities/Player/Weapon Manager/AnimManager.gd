extends Node
class_name AnimManager

@export var anims: AnimationPlayer

var cw: WeaponData # Current weapon
var cw_model: Node3D # Current weapon model


func get_current_weapon(current_weapon: WeaponData, current_weapon_model: Node3D):
	cw = current_weapon
	cw_model = current_weapon_model


func play_animation(anim_name: String, anim_speed: float, restart: bool = true):
	if cw != null and anims != null:
		if restart and anims.current_animation == anim_name:
			anims.seek(0.0, true)
		anims.play(anim_name, -1, anim_speed)
