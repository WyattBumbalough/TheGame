class_name Breadcrumb extends Node3D

@onready var timer: Timer = $Timer


func _ready() -> void:
	timer.timeout.connect(func(): queue_free())
