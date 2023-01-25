extends KinematicBody

var timer : float
var speed := 2.0
var offset

var xCoord
var zCoord

var targetX
var targetZ

# TODO: Find a better way to get info from world tiles
var world

func _ready():
	pass # Replace with function body.


func _process(delta):
	timer += delta
	if timer > speed:
		timer = 0
		
		# Wander idly
		var nearbyTiles = world.getNearbyEmptyTiles(xCoord, zCoord)
		if(nearbyTiles.size() > 0):
			var target = randi() % nearbyTiles.size()
			xCoord = nearbyTiles[target].xCoord
			zCoord = nearbyTiles[target].zCoord
			transform.origin = Vector3(xCoord * offset, 0, zCoord * offset)
			print("Villager tries to move.", nearbyTiles.size(), " available tiles.", target, " selected.")


func _physics_process(delta):
	pass


func initialise(x, z, positionOffset, worldObject):
	xCoord = x
	zCoord = z
	offset = positionOffset
	world = worldObject
	transform.origin = Vector3(xCoord * offset, 0, zCoord * offset)
