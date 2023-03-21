extends Node3D

var timer = 0
var timerReset


func _ready():
	timerReset = randf_range(1, 5)
	var material = StandardMaterial3D.new()
	$Wall.set_surface_override_material(0, material)
	$Floor.set_surface_override_material(0, material)
	connect("mouse_entered", Callable(self, "_on_mouse_enter"))
	connect("mouse_exited", Callable(self, "_on_mouse_exit"))


func _process(delta):
	timer += delta
	if timer > timerReset:
		toggleWall()
		timer = 0

func _on_mouse_enter():
	setColour(Color.BLUE)
	
func _on_mouse_exit():
	setColour(Color.WHITE)

func initialise(x, z):
	transform.origin = Vector3(x, 0, z)

func setColour(colour):
	var material = $Wall.get_surface_override_material(0)
	material.albedo_color = colour
	$Wall.set_surface_override_material(0, material)
	$Floor.set_surface_override_material(0, material)

func toggleWall():
	var state = !$Wall.visible
	
	$Wall.visible = state
	$CollisionWall.visible = state
	$CollisionFloor.visible = !state
