extends Spatial

var timer = 0
var timerReset


func _ready():
	timerReset = rand_range(1, 5)
	var material = SpatialMaterial.new()
	$Wall.set_surface_material(0, material)
	$Floor.set_surface_material(0, material)
	connect("mouse_entered", self, "_on_mouse_enter")
	connect("mouse_exited", self, "_on_mouse_exit")


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
	var material = $Wall.get_surface_material(0)
	material.albedo_color = colour
	$Wall.set_surface_material(0, material)
	$Floor.set_surface_material(0, material)

func toggleWall():
	var state = !$Wall.visible
	
	$Wall.visible = state
	$CollisionWall.visible = state
	$CollisionFloor.visible = !state
