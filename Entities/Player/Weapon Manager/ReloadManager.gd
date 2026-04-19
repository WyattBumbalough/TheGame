extends Node
class_name  ReloadManager

@export var weapon_manager: WeaponManager
@export var ammo_manager: AmmoManager
@export var anim_manager: AnimManager

var cw: WeaponData # Current weapon

var reload_time: float
var current_part_index: int
var start_reload_timer: bool = false
var play_sound_and_anim: bool = false
var force_reload_stop: bool = false


func get_current_weapon(current_weapon: WeaponData):
	cw = current_weapon


func _process(delta: float) -> void:
	if cw.is_reloading and start_reload_timer and not force_reload_stop:
		pass


func reload():
	reload_start()


func reload_start():
	if !cw.is_reloading and ammo_manager.ammo[cw.ammo_type] > 0 and \
	cw.current_ammo != cw.max_ammo_capacity and \
	!cw.is_shooting:
		cw.is_reloading = true
		
		if (cw.max_ammo_capacity % cw.reload_parts_needed) != 0:
			push_error("Cannot insert % amount of ammo." % (cw.reload_parts_needed / cw.max_ammo_capacity))
			cw.is_reloading = false
		else:
			current_part_index = 0
			reload_time = cw.time_per_reload_part
			force_reload_stop = false
			play_sound_and_anim = true
			start_reload_timer = true
	else:
		print("Don't need to reload.")


func reload_follow(delta: float):
	if play_sound_and_anim:
		play_sound_and_anim = false
		weapon_manager.weapon_sound_player(cw.reload_sound, cw.reload_sound_speed)
		if cw.reload_anim_name != "":
			anim_manager.play_animation(cw.reload_anim_name, cw.reload_anim_speed)
		else:
			print("%s does not have a reload animation." % cw.weapon_name)
	
	if reload_time > 0.0: reload_time -= delta
	else:
		if current_part_index < cw.reload_parts_needed:
			if cw.reload_parts_needed == 1:
				one_part_calc()
			else:
				multi_part_calc()
			
	
func one_part_calc():
	print("haven't done this yet.")


func multi_part_calc():
	print("aaa")
