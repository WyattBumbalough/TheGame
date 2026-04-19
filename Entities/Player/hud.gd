extends Control


@export var weapon_manager: WeaponManager

@onready var wep_name: Label = %WepName
@onready var current_mag: Label = %CurrentMag
@onready var reserve: Label = %Reserve


func _process(_delta: float) -> void:
	if weapon_manager.cw != null:
		wep_name.text = weapon_manager.cw.weapon_name
		current_mag.text = str(weapon_manager.cw.current_ammo)
		reserve.text = str(weapon_manager.ammo_manager.ammo[weapon_manager.cw.ammo_type])
