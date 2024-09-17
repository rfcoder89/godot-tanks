extends Node3D

@export var camera : Camera3D = null
@export var control : bool = false;
var moveForwards : bool = false
var moveBackwards : bool = false

var cameraDistance : float = 2;
var cameraYAngle : float = 0;
var cameraXAngle : float = 0;

@export var mouseInput : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var viewport_transform: Transform2D = get_tree().root.get_final_transform()
		mouseInput += event.xformed_by(viewport_transform).relative

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !control:
		return
		
	if camera.get_parent() != $CameraAnchor:
		camera.reparent($CameraAnchor)
		camera.transform.origin = Vector3.ZERO
		
	cameraYAngle += mouseInput.x * delta * 0.3
	while cameraYAngle < 0:	  cameraYAngle += TAU
	while cameraYAngle > TAU: cameraYAngle -= TAU
	
	mouseInput = Vector2.ZERO
	
	#$CameraAnchor.transform.origin = Vector3(-1, 0, 0)
	var cat : Transform3D = Transform3D()  # camera anchor transform
	cat = cat.translated(Vector3(6, 2.5, 0))
	cat = cat.rotated(Vector3(0, 1, 0), -cameraYAngle)
	$CameraAnchor.transform.origin = cat.origin
	$CameraAnchor.look_at(to_global(Vector3(0, 2, 0)))
	
	if (Input.is_action_pressed("Move forward") and !moveForwards):
		moveForwards = true
		moveBackwards = false;
		
	if (Input.is_action_pressed("Move backwards") and !moveBackwards):
		moveForwards = false
		moveBackwards = true;		

	if moveForwards:
		self.transform.origin += Vector3(0.3, 0, 0)
	else:
		if moveBackwards:
			self.transform.origin -= Vector3(0.3, 0, 0) 
	
