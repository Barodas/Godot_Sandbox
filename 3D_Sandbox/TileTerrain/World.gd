extends Spatial

export (PackedScene) var tileScene

var width = 10
var depth = 10

var tiles = []

func _ready():
	# Generate Terrain Tiles
	for x in width:
		tiles.append([])
		for z in depth:
			var instance = tileScene.instance()
			instance.initialise(x, z, 2)
			instance.connect("tile_clicked", self, "_on_tile_clicked")
			tiles[x].append(instance)
			add_child(instance)

func _on_tile_clicked(x, z):
#	tiles[x][z].isClicked = true
	tiles[x][z].selectTile()
