extends Node3D

@export var camera : Camera3D = null
@export var control : bool = false;

var moveDir : int = 0

var cameraDistance : float = 2;
var cameraYAngle : float = 0;
var turretAngle : float = 0;

@onready var cameraAnchor : Node3D = $CameraAnchor
@export var mouseInput : Vector2

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var viewport_transform: Transform2D = get_tree().root.get_final_transform()
		mouseInput += event.xformed_by(viewport_transform).relative

func _physics_process(delta: float) -> void:
	if moveDir == 0:
		var lv = $RigidBody3D.linear_velocity.length()
		var brakeForce : Vector3 = Vector3(lv * 0.4, 0, 0) * Vector3(1, 0, 0).dot($RigidBody3D.linear_velocity) * -0.4;
		$RigidBody3D.add_constant_central_force(brakeForce)
		return
	
	var maxSpeed = 6;
	if $RigidBody3D.linear_velocity.length() < maxSpeed:
		$RigidBody3D.add_constant_central_force(Vector3(0.8 * moveDir, 0, 0))
	else:
		$RigidBody3D.linear_velocity = $RigidBody3D.linear_velocity.limit_length(maxSpeed)

func _process(delta: float) -> void:
	if !control:
		return
		
	if camera.get_parent() != cameraAnchor:
		camera.reparent(cameraAnchor)
		camera.transform.origin = Vector3.ZERO
		
	cameraYAngle += mouseInput.x * delta * 0.3
	while cameraYAngle < 0:	  cameraYAngle += TAU
	while cameraYAngle > TAU: cameraYAngle -= TAU
	mouseInput = Vector2.ZERO
	
	var cat : Transform3D = Transform3D()  # camera anchor transform
	cat = cat.translated(Vector3(7, 2.5, 0))
	cat = cat.rotated(Vector3(0, 1, 0), -cameraYAngle)
	cat = cat.translated($RigidBody3D.transform.origin)
	
	cameraAnchor.transform.origin = cat.origin
	cameraAnchor.look_at($RigidBody3D.transform.origin + Vector3(0, 2, 0))
	
	if Input.is_action_pressed("Move forward"):
		moveDir = 1
	elif Input.is_action_pressed("Move backwards"):
		moveDir = -1
	else:
		moveDir = 0
