extends Node
class_name  ReloadManager

var cw: WeaponData # Current weapon


func get_current_weapon(current_weapon: WeaponData):
	cw = current_weapon


func reload():
	print("reloading!")
