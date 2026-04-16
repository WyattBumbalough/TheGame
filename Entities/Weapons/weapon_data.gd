extends Resource
class_name WeaponData

@export_group("General Settings")
@export var weapon_name: String
@export var weapon_id: int ## Must match ID of weapon slot in weapon manager.
var weapon_slot: WeaponSlot

@export_group("Attack Settings")
var is_shooting: bool = false
@export var weapon_damage: float
@export var headshot_damage_multiplier: float = 2.0
@export var projectiles_per_shot: int = 1
@export var min_spread: float
@export var max_spread: float
@export var damage_dropoff: Curve

@export_group("Ammo Settings")
@export var max_ammo_capacity: int
@export var ammo_type: String = ""
@export var current_ammo: int
@export var current_reserve_ammo: int

@export_group("Reload Settings")
var is_reloading: bool = false
@export var reload_time: float

@export_group("Animation Settings")
@export var equip_anim_name: String
@export var equip_anim_speed: float = 1.0
@export var shoot_anim_name: String
@export var shoot_anim_speed: float = 1.0
@export var reload_anim_name: String
@export var reload_anim_speed: float = 1.0

@export_group("Position Settings")
@export var equipped_position: Vector3 = Vector3.ZERO
@export var unequipped_position: Vector3 = Vector3.ZERO

@export_group("Muzzle Flash")
@export var muzzle_flash_ref: PackedScene
