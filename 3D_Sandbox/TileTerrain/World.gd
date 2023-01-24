extends Spatial

export (PackedScene) var tileScene

var width = 10
var depth = 10

var tiles = []

var isSelecting
var hasSelection
var selectStartIndexX
var selectStartIndexZ
var selectEndIndexX
var selectEndIndexZ

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

func _process(delta):
	if(Input.is_action_just_pressed("mouse_right_click")):
		# Clear selection
		if(hasSelection):
			# Clear tile states if we had completed the selection
			# TODO: Move code below into a function with bool to either activate/deactivate selected tiles
			var minX = min(selectStartIndexX, selectEndIndexX)
			var maxX = max(selectStartIndexX, selectEndIndexX)
			var minZ = min(selectStartIndexZ, selectEndIndexZ)
			var maxZ = max(selectStartIndexZ, selectEndIndexZ)
			
			for x in range(minX, maxX + 1):
				for z in range(minZ, maxZ + 1):
					tiles[x][z].selectTile(false)
		
		hasSelection = false
		isSelecting = false
	
	if(hasSelection):
		# Highlight all tiles that are in selection box
		var minX = min(selectStartIndexX, selectEndIndexX)
		var maxX = max(selectStartIndexX, selectEndIndexX)
		var minZ = min(selectStartIndexZ, selectEndIndexZ)
		var maxZ = max(selectStartIndexZ, selectEndIndexZ)
		
		for x in range(minX, maxX + 1):
			for z in range(minZ, maxZ + 1):
				tiles[x][z].selectTile(true)


func _on_tile_clicked(x, z):
#	tiles[x][z].isClicked = true
	#tiles[x][z].toggleTile()
	
	if(!hasSelection):
		if(!isSelecting):
			# Start Selection
			isSelecting = true
			selectStartIndexX = x
			selectStartIndexZ = z
		else:
			# Finish Selection
			isSelecting = false
			hasSelection = true
			selectEndIndexX = x
			selectEndIndexZ = z
