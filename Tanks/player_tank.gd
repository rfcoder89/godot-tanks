extends Node3D

@export var camera : Camera3D = null
@export var control : bool = false;
var moveForwards : bool = false
var moveBackwards : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !control:
		return
		
	if camera.get_parent() != $CameraAnchor:

		print(camera.transform.origin)
		camera.reparent($CameraAnchor)
		camera.transform.origin = Vector3.ZERO
		print(camera.transform.origin)
		# camera.transform.origin = Vector3.ZERO
		
	#$CameraAnchor.look_at($Tank.transform.origin)
	
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
	
