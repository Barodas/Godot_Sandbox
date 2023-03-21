extends Camera3D


var speed = 3


func _ready():
	pass 


func _process(delta):
	var move_x = 0
	var move_z = 0
	
	if Input.is_action_pressed("camera_left"):
		move_x = -1
	if Input.is_action_pressed("camera_right"):
		move_x = 1
	if Input.is_action_pressed("camera_forward"):
		move_z = -1
	if Input.is_action_pressed("camera_back"):
		move_z = 1
	
	transform.origin = transform.origin + Vector3((move_x * speed) * delta, 0, (move_z * speed) * delta)
