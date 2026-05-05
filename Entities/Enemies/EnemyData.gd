class_name EnemyData extends Resource

@export_group("Basic settings")
@export var enemy_name: String = ""
@export var detection_range: float = 15.0
@export var detection_time: float = 1.0
@export var hitspark: PackedScene

@export_group("Navigation settings")
@export var movement_speed: float = 10.0
@export var min_nav_start_delay: float = 0.15 ##Minumum amount of time to wait before starting navigation.
@export var mx_nav_start_delay: float = .75 ##Maximum amount of time to wait before starting navigation.

@export_group("Attack Settings")
@export var attack_damage: float = 10.0
@export var attack_range: float = 5.0
@export var attack_startup_time: float = 0.5
@export var attack_recovery_time: float = 0.15
@export var attack_projectile: PackedScene

@export_group("Animation Settings")
@export var idle_anim_name: String = ""
@export var idle_anim_speed: float = 1.0
@export var move_anim_name: String = ""
@export var move_anim_speed: float = 1.0
@export var aim_anim_name: String = ""
@export var aim_anim_speed: float = 1.0
@export var attack_anim_name: String = ""
@export var attack_anim_speed: float = 1.0
@export var death_anim_name: String = ""
@export var death_anim_speed: float = 1.0


@export_group("Sounds")
@export var detection_sound: AudioStream
@export var attack_sound: AudioStream
@export var aim_sound: AudioStream
@export var damaged_sound: AudioStream
@export var killed_sound: AudioStream
