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
		reload_follow(delta)


func reload():
	reload_start()


# Check that the player is able to reload and set all appropraite variables.
func reload_start():
	if !cw.is_reloading and ammo_manager.ammo[cw.ammo_type] > 0 and \
	cw.current_ammo != cw.max_ammo_capacity and \
	!cw.is_shooting:
		cw.is_reloading = true
		
		if cw.rounds_reload:
			cw.reload_parts_needed = cw.max_ammo_capacity - cw.current_ammo
		else:
			cw.reload_parts_needed = 1

		current_part_index = 0
		reload_time = cw.time_per_reload_part
		force_reload_stop = false
		play_sound_and_anim = true
		start_reload_timer = true
	else:
		print("Don't need to reload.")


# Play sound and animations. 
func reload_follow(delta: float):
	if play_sound_and_anim:
		play_sound_and_anim = false
		
		if cw.reload_anim_name != "":
			anim_manager.play_animation(cw.reload_anim_name, cw.reload_anim_speed)
			#weapon_manager.weapon_sound_player(cw.reload_start_sound, cw.reload_sound_speed)
		else:
			print("%s does not have a reload animation." % cw.weapon_name)
	
	if reload_time > 0.0: reload_time -= delta
	else:
		if current_part_index < cw.reload_parts_needed:
			if cw.rounds_reload:
				multi_part_calc()
			else:
				one_part_calc()
		
	
func one_part_calc():
	print("haven't done this yet.")
	return


func multi_part_calc():
	#var ammo_to_refill = cw.max_ammo_capacity - cw.current_ammo

	if ammo_manager.ammo[cw.ammo_type] > 0 and \
	cw.current_ammo <= cw.max_ammo_capacity - 1:
		# Add number of ammo to the mag and subtract it from the ammo manager.
		cw.current_ammo += 1
		ammo_manager.ammo[cw.ammo_type] -= 1
		reload_time = cw.time_per_reload_part
		weapon_manager.weapon_sound_player(cw.reload_sound, cw.reload_sound_speed)
	else:
		print("not enough ammo in reserve, or magazine complete")
		anim_manager.play_animation(cw.equip_anim_name, cw.equip_anim_speed)
		cw.is_reloading = false
		force_reload_stop = true
	
