extends Spatial

var timer = 0
var timerReset


func _ready():
	timerReset = rand_range(1, 5)
	var material = SpatialMaterial.new()
	$Wall/Mesh.set_surface_material(0, material)
	$Floor/Mesh.set_surface_material(0, material)
	$Floor.connect("mouse_entered", self, "_on_mouse_enter")
	$Floor.connect("mouse_exited", self, "_on_mouse_exit")
	$Wall.connect("mouse_entered", self, "_on_mouse_enter")
	$Wall.connect("mouse_exited", self, "_on_mouse_exit")


func _process(delta):
	timer += delta
	if timer > timerReset:
		toggleWall()
		timer = 0


func _on_mouse_enter():
	setColour(Color.blue)


func _on_mouse_exit():
	setColour(Color.white)


func initialise(x, z):
	transform.origin = Vector3(x, 0, z)


func setColour(colour):
	var material = $Wall/Mesh.get_surface_material(0)
	material.albedo_color = colour
	$Wall/Mesh.set_surface_material(0, material)
	$Floor/Mesh.set_surface_material(0, material)


func toggleWall():
	var state = !$Wall.visible
	
	$Wall.visible = state
	$Wall/Collision.visible = state
	$Floor/Collision.visible = !state

