class_name EnemyVisuals
extends Node3D

signal anim_finished(anim_name)

@export_enum("Runny", "Sticky", "Perfect") var poopy_type: String
@export var anims: AnimationPlayer
var enemy_data: EnemyData


func _ready() -> void:
	anims.animation_finished.connect(_on_anim_finished)


func play_animation(anim_name: String, speed: float = 1.0, blend_time: float = -1.0):
	if anims.has_animation(anim_name):
		anims.play(anim_name, blend_time, speed)
	else:
		printerr("Animation %s not found." % anim_name)


func stop_animation():
	anims.stop()

func _on_anim_finished(_name: String):
	anim_finished.emit(_name)
