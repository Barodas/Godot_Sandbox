extends KinematicBody

# TODO: Find a better way to get info from world tiles
onready var World = get_parent()

var timer : float
var speed := 2.0
var offset

var x_coord
var z_coord

var target_x
var target_z

func _ready():
	pass # Replace with function body.

func _process(delta):
	timer += delta
	if timer > speed:
		timer = 0
		
		# Wander idly
		var nearby_tiles = World.get_nearby_empty_tiles(x_coord, z_coord)
		if(nearby_tiles.size() > 0):
			var target = randi() % nearby_tiles.size()
			x_coord = nearby_tiles[target].x_coord
			z_coord = nearby_tiles[target].z_coord
			transform.origin = Vector3(x_coord * offset, 0, z_coord * offset)
			print("Villager tries to move.", nearby_tiles.size(), " available tiles.", target, " selected.")

func _physics_process(delta):
	pass

func initialise(x, z, position_offset):
	x_coord = x
	z_coord = z
	offset = position_offset
	transform.origin = Vector3(x_coord * offset, 0, z_coord * offset)
