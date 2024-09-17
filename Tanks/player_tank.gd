extends Node3D

@export var camera : Camera3D = null
@export var control : bool = false;

var moveDir : int = 0
var rotateDir: int = 0

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
	var localDir = ($RigidBody3D.basis * Vector3(1, 0, 0)).normalized()
	if moveDir == 0:
		var lv = $RigidBody3D.linear_velocity
		$RigidBody3D.linear_velocity *= 0.8
		$RigidBody3D.constant_force = Vector3.ZERO
		#var brakeForce : Vector3 = lv * -0.3;
		#brakeForce.y = 0;
		#$RigidBody3D.add_constant_central_force(brakeForce)
	else:
		var maxSpeed = 6;
		print($RigidBody3D.linear_velocity)
		if $RigidBody3D.linear_velocity.length() < maxSpeed:
			$RigidBody3D.constant_force = localDir * 30.8 * moveDir
		else:
			$RigidBody3D.linear_velocity = $RigidBody3D.linear_velocity.limit_length(maxSpeed)
			$RigidBody3D.constant_force = Vector3.ZERO
			
	if rotateDir == 0:
		$RigidBody3D.angular_velocity *= 0.8
		$RigidBody3D.constant_torque = Vector3.ZERO
	else:
		#print($RigidBody3D.angular_velocity)
		var maxSpeed = 6;
		if abs($RigidBody3D.angular_velocity.y) < maxSpeed:
			$RigidBody3D.constant_torque = Vector3(0, 20.8 * -rotateDir, 0)
			print($RigidBody3D.constant_torque)
		else:
			$RigidBody3D.angular_velocity = Vector3(
				$RigidBody3D.angular_velocity.x,
				max(-maxSpeed, min(maxSpeed, $RigidBody3D.angular_velocity.y)),
				$RigidBody3D.angular_velocity.z
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
		
	if Input.is_action_pressed("Rotate right"):
		rotateDir = 1
	elif Input.is_action_pressed("Rotate left"):
		rotateDir = -1
	else:
		rotateDir = 0
