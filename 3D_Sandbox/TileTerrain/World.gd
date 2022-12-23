extends Spatial

# var tileScene = load("res://Tile.tscn")
export (PackedScene) var tileScene

var width = 10
var depth = 10

func _ready():
	for x in width:
		for z in depth:
			var position = Vector2(x, z)
			var instance = tileScene.instance()
			instance.initialise(x * 2, z * 2)
			add_child(instance)

func _physics_process(delta):
	var space_state = get_world().direct_space_state
