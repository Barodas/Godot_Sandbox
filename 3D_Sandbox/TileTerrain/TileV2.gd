extends Spatial

signal tile_mouse_enter(x, z)
signal tile_mouse_exit(x, z)

var timer = 0
var timerReset

var xCoord
var zCoord

var isHovered
var isSelected


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
#	if isHovered && Input.is_action_just_pressed("mouse_left_click"):
#		emit_signal("tile_clicked", xCoord, zCoord)
	pass


func _on_mouse_enter():
	isHovered = true
	emit_signal("tile_mouse_enter", xCoord, zCoord)
	processState()


func _on_mouse_exit():
	isHovered = false
	emit_signal("tile_mouse_exit", xCoord, zCoord)
	processState()


func initialise(x, z, offset, initialState):
	transform.origin = Vector3(x * offset, 0, z * offset)
	xCoord = x
	zCoord = z
	setWall(initialState != 0)


func processState():
	if(isSelected):
		if(isHovered):
			setColour(Color.orange)
		else:
			setColour(Color.red)
	else:
		if(isHovered):
			setColour(Color.blue)
		else:
			setColour(Color.white)


func setColour(colour):
	var material = $Wall/Mesh.get_surface_material(0)
	material.albedo_color = colour
	$Wall/Mesh.set_surface_material(0, material)
	$Floor/Mesh.set_surface_material(0, material)


func toggleTile():
	selectTile(!isSelected)


func selectTile(state):
	isSelected = state
	processState()


func toggleWall():
	setWall(!$Wall.visible)


func setWall(state):
	$Wall.visible = state
	$Wall/Collision.visible = state
	$Floor/Collision.visible = !state
