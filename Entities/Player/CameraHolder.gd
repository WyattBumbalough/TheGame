extends Node3D
class_name CameraHolder

@export_group("Camera settings")
@export_range(0.0,5.0,0.01) var x_axis_sens: float
@export_range(0.0,5.0,0.01) var y_axis_sens: float

@export_group("Camera Tilt Settings")
@export var enable_camera_tilt: bool = true
@export var tilt_rotation: float = 0.4
@export var tilt_speed: float= 2.0

@export var player: Player

var player_input: Vector2

func _process(delta: float) -> void:
	if enable_camera_tilt:
		if player.input_direction != Vector2.ZERO:
			player_input = player.input_direction
			if not player.is_on_floor():
				return
			else:
				rotation.z = lerp(rotation.z, -player_input.x * tilt_rotation, tilt_speed * delta)
		else:
			rotation.z = lerp(rotation.z, 0.0, 8.0 * delta)
