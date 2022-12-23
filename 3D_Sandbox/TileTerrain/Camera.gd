extends Spatial

var panSpeed = 5


func _ready():
	pass # Replace with function body.


func _process(delta):
	var curPos = transform.origin
	var move = Vector3(0,0,0)
	var distance = panSpeed * delta
	
	if Input.is_action_pressed("ui_right"):
		move.x = distance
	if Input.is_action_pressed("ui_left"):
		move.x = -distance
	if Input.is_action_pressed("ui_up"):
		move.z = -distance
	if Input.is_action_pressed("ui_down"):
		move.z = distance
	
	transform.origin = curPos + move
