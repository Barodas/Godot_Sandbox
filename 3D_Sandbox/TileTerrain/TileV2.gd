extends Node3D

signal tile_mouse_enter(x, z)
signal tile_mouse_exit(x, z)

var timer = 0
var timerReset

var x_coord
var z_coord

var is_hovered
var is_selected

func _ready():
	timerReset = randf_range(1, 5)
	var material = StandardMaterial3D.new()
	$Wall/Mesh.set_surface_override_material(0, material)
	$Floor/Mesh.set_surface_override_material(0, material)
	$Floor.connect("mouse_entered", Callable(self, "_on_mouse_enter"))
	$Floor.connect("mouse_exited", Callable(self, "_on_mouse_exit"))
	$Wall.connect("mouse_entered", Callable(self, "_on_mouse_enter"))
	$Wall.connect("mouse_exited", Callable(self, "_on_mouse_exit"))

func _process(delta):
	pass

func _on_mouse_enter():
	is_hovered = true
	emit_signal("tile_mouse_enter", x_coord, z_coord)
	process_state()

func _on_mouse_exit():
	is_hovered = false
	emit_signal("tile_mouse_exit", x_coord, z_coord)
	process_state()

func initialise(x, z, offset, initialState):
	transform.origin = Vector3(x * offset, 0, z * offset)
	x_coord = x
	z_coord = z
	set_wall(initialState == 1)

func process_state():
	if(is_selected):
		if(is_hovered):
			set_colour(Color.ORANGE)
		else:
			set_colour(Color.RED)
	else:
		if(is_hovered):
			set_colour(Color.BLUE)
		else:
			set_colour(Color.WHITE)

func set_colour(colour):
	var material = $Wall/Mesh.get_surface_override_material(0)
	material.albedo_color = colour
	$Wall/Mesh.set_surface_override_material(0, material)
	$Floor/Mesh.set_surface_override_material(0, material)

func toggle_tile():
	select_tile(!is_selected)

func select_tile(state):
	is_selected = state
	process_state()

func toggle_wall():
	set_wall(!$Wall.visible)

func set_wall(state):
	$Wall.visible = state
	$Wall/Collision.visible = state
	$Floor/Collision.visible = !state

func get_wall():
	return $Wall.visible
