extends Node
class_name AmmoManager

# Currently held ammo of each type
# Key = ammo_type, value = ammo starting amount.
var ammo: Dictionary = { 
	"Pistol": 26,
	"Shells": 12,
	"SMG": 40,
	"Rifle": 14
}

var max_ammo_per_type: Dictionary = {
	"Pistol": 80,
	"Shells": 40,
	"SMG": 150,
	"Rifle": 25
}
