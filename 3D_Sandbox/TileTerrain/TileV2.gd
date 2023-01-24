extends Spatial

signal tile_clicked(x, z)

var timer = 0
var timerReset

var xCoord
var zCoord
var isHovered

var isClicked

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
#	timer += delta
#	if timer > timerReset:
#		toggleWall()
#		timer = 0
	if isHovered && Input.is_action_just_pressed("mouse_left_click"):
		emit_signal("tile_clicked", xCoord, zCoord)


func _on_mouse_enter():
	isHovered = true
	if !isClicked:
		setColour(Color.blue)
	else:
		setColour(Color.orange)


func _on_mouse_exit():
	isHovered = false
	if !isClicked:
		setColour(Color.white)
	else:
		setColour(Color.red)


func initialise(x, z, offset):
	transform.origin = Vector3(x * offset, 0, z * offset)
	xCoord = x
	zCoord = z


func setColour(colour):
	var material = $Wall/Mesh.get_surface_material(0)
	material.albedo_color = colour
	$Wall/Mesh.set_surface_material(0, material)
	$Floor/Mesh.set_surface_material(0, material)


func toggleTile():
	selectTile(!isClicked)


func selectTile(state):
	isClicked = state
	
	if(isClicked):
		setColour(Color.orange)
	else:
		setColour(Color.blue)


func toggleWall():
	var state = !$Wall.visible
	
	$Wall.visible = state
	$Wall/Collision.visible = state
	$Floor/Collision.visible = !state

