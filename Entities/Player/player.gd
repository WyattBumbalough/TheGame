extends CharacterBody3D
class_name  Player


const JUMP_VELOCITY = 4.5
const SENS = .002

@export_group("Controls mapping")
@export var MOVE_FORWARD: String = "up"
@export var MOVE_BACK: String = "down"
@export var MOVE_LEFT: String = "left"
@export var MOVE_RIGHT: String = "right"
@export var JUMP: String = "jump"
@export var CROUCH: String = "crouch"
@export var SPRINT: String = "sprint"
@export var PAUSE: String = "pause"

@export_group("Toggles")
@export var allow_move: bool = true
@export var allow_jump: bool = true
@export var allow_crouch: bool = true
@export var allow_sprint: bool = true

@onready var head: Node3D = %CameraHolder
@onready var camera: Camera3D = %Camera
@onready var state_machine: StateMachine = %StateMachine
@onready var crosshair: Crosshair = %Crosshair
@onready var bob_anims: AnimationPlayer = $BobAnims


var input_direction: Vector2

var tween: Tween
var base_fov: float

func _ready() -> void:
	Refs.PLAYER = self
	state_machine.initialize(self)
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	base_fov = camera.fov
	
	head.rotation.y = rotation.y
	rotation.y = 0.0


func _check_controls() -> void:
	if !InputMap.has_action(MOVE_FORWARD):
		push_error("No control mapped for 'move_forward', using default...")
		_add_input_map_event(MOVE_FORWARD, KEY_W)
	if !InputMap.has_action(MOVE_BACK):
		push_error("No control mapped for 'move_back', using default...")
		_add_input_map_event(MOVE_BACK, KEY_S)
	if !InputMap.has_action(MOVE_LEFT):
		push_error("No control mapped for 'move_left', using default...")
		_add_input_map_event(MOVE_LEFT, KEY_A)
	if !InputMap.has_action(MOVE_RIGHT):
		push_error("No control mapped for 'move_right', using default...")
		_add_input_map_event(MOVE_RIGHT, KEY_D)
	if !InputMap.has_action(JUMP):
		push_error("No control mapped for 'jump', using default...")
		_add_input_map_event(JUMP, KEY_SPACE)
	if !InputMap.has_action(CROUCH):
		push_error("No control mapped for 'crouch', using default...")
		_add_input_map_event(CROUCH, KEY_C)
	if !InputMap.has_action(SPRINT):
		push_error("No control mapped for 'sprint', using default...")
		_add_input_map_event(SPRINT, KEY_SHIFT)
	if !InputMap.has_action(PAUSE):
		push_error("No control mapped for 'pause', using default...")
		_add_input_map_event(PAUSE, KEY_ESCAPE)


func _add_input_map_event(action_name: String, keycode: int) -> void:
	var event = InputEventKey.new()
	event.keycode = keycode
	InputMap.add_action(action_name)
	InputMap.action_add_event(action_name, event)


func _unhandled_input(event: InputEvent) -> void:
	state_machine.handle_input(event)
	if event is InputEventMouseMotion:
		head.rotate_y( -event.relative.x * SENS )
		camera.rotate_x( -event.relative.y * SENS )
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))
	if Input.is_action_just_pressed("pause"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	state_machine.handle_physics(delta)
	
	if allow_move:
		if Input.get_vector(MOVE_LEFT, MOVE_RIGHT, MOVE_FORWARD, MOVE_BACK):
			input_direction = Input.get_vector(MOVE_LEFT, MOVE_RIGHT, MOVE_FORWARD, MOVE_BACK)
		else:
			input_direction = Vector2.ZERO
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	%Label.text = state_machine.current_state.name

	move_and_slide()


func handle_movement(speed: float, acceleration: float, friction: float):
	var input_dir := Input.get_vector(MOVE_LEFT, MOVE_RIGHT, MOVE_FORWARD, MOVE_BACK)
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if is_on_floor():
		if direction:
			velocity.x = lerp(velocity.x, direction.x * speed, acceleration)
			velocity.z = lerp(velocity.z, direction.z * speed, acceleration)
		else:
			velocity.x = lerp(velocity.x, 0.0, friction)
			velocity.z = lerp(velocity.z, 0.0, friction)
	else:
		if direction:
			velocity.x = lerp(velocity.x, direction.x * speed, acceleration)
			velocity.z = lerp(velocity.z, direction.z * speed, acceleration)


func tween_cam_fov_up():
	camera.fov = base_fov * 1.025
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_parallel(false)
	tween.set_trans(Tween.TRANS_SINE)
	#tween.tween_property(camera, "fov", camera.fov * 1.05, 0.05)
	tween.tween_property(camera, "fov", base_fov, 0.25)


func tween_cam_fov_down():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(camera, "fov", base_fov, 0.75)
	
