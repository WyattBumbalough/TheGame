class_name EnemyVisuals
extends Node3D

@export_enum("Runny", "Sticky", "Perfect") var poopy_type: String
@export var anims: AnimationPlayer


func play_animation(anim_name: String, speed: float = 1.0, blend_time: float = -1.0):
	if anims.has_animation(anim_name):
		anims.play(anim_name, blend_time, speed)
	else:
		printerr("Animation %s not found." %anim_name)
