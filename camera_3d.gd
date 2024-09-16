extends Camera3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("Move forward"):
		self.position += Vector3(1, 0, 0);
