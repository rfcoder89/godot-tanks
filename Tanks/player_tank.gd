extends Node3D

@export var camera : Camera3D = null
@export var moveForwards : bool = false
@export var moveBackwards : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_pressed("Move forward")):
		moveForwards = true
		moveBackwards = false;
		
	if (Input.is_action_pressed("Move backwards")):
		moveForwards = false
		moveBackwards = true;		

	if moveForwards:
		self.transform.origin += Vector3(0.3, 0, 0)
	else:
		if moveBackwards:
			self.transform.origin -= Vector3(0.3, 0, 0) 
	
