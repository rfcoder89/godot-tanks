extends Node3D

@export var camera : Camera3D = null
@export var control : bool = false;

var moveDir : int = 0
var rotateDir: int = 0
var rotateTurretDir: int = 0;

var cameraDistance : float = 2;
var cameraYAngle : float = 0;
var turretAngle : float = 0;

@onready var cameraAnchor : Node3D = $CameraAnchor
@onready var rb : RigidBody3D = $RigidBody3D

@export var mouseInput : Vector2

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var viewport_transform: Transform2D = get_tree().root.get_final_transform()
		mouseInput += event.xformed_by(viewport_transform).relative

func _physics_process(delta: float) -> void:
	var localDir = (rb.basis * Vector3(1, 0, 0)).normalized()
	if moveDir == 0:
		var lv = rb.linear_velocity
		var yVel : float = rb.linear_velocity.y;
		rb.linear_velocity *= 0.8;
		rb.linear_velocity.y = yVel;
		rb.constant_force = Vector3.ZERO
	else:
		var maxSpeed = 6;
		print(rb.linear_velocity)
		if rb.linear_velocity.length() < maxSpeed:
			rb.constant_force = localDir * 30.8 * moveDir
		else:
			rb.linear_velocity = rb.linear_velocity.limit_length(maxSpeed)
			rb.constant_force = Vector3.ZERO
			
	if rotateDir == 0:
		rb.angular_velocity *= 0.8
		rb.constant_torque = Vector3.ZERO
	else:
		var maxSpeed = 6;
		if abs(rb.angular_velocity.y) < maxSpeed:
			rb.constant_torque = Vector3(0, 20.8 * -rotateDir, 0)
			print(rb.constant_torque)
		else:
			rb.angular_velocity = Vector3(
				rb.angular_velocity.x,
				max(-maxSpeed, min(maxSpeed, rb.angular_velocity.y)),
				rb.angular_velocity.z
			)	

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
	cat = cat.translated(Vector3(-7, 2.5, 0))
	cat = cat.rotated(Vector3(0, 1, 0), -cameraYAngle)
	cat = cat.translated(rb.transform.origin)	
	cameraAnchor.transform.origin = cat.origin
	cameraAnchor.look_at(rb.transform.origin + Vector3(0, 2, 0))
	
	turretAngle += rotateTurretDir * -5 * delta;
	$RigidBody3D/Tank/TanksTurretMesh001.set_rotation(Vector3(0, turretAngle, 0))
	
	if Input.is_action_pressed("Move forward"):
		moveDir = 1
	elif Input.is_action_pressed("Move backwards"):
		moveDir = -1
	else:
		moveDir = 0
		
	if Input.is_action_pressed("Rotate right"):
		rotateDir = 1
	elif Input.is_action_pressed("Rotate left"):
		rotateDir = -1
	else:
		rotateDir = 0
		
	if Input.is_action_pressed("Rotate turret right"):
		rotateTurretDir = 1
	elif Input.is_action_pressed("Rotate turret left"):
		rotateTurretDir = -1
	else:
		rotateTurretDir = 0
