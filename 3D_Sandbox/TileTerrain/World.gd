extends Spatial

export (PackedScene) var tileScene

var width = 10
var depth = 10

var tiles = []

var isHovering
var hoverX
var hoverZ

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
			instance.connect("tile_mouse_enter", self, "_on_tile_hover_enter")
			instance.connect("tile_mouse_exit", self, "_on_tile_hover_exit")
			tiles[x].append(instance)
			add_child(instance)


func _process(delta):
	if isHovering && Input.is_action_just_pressed("mouse_left_click"):
		selectTile(hoverX, hoverZ)
	
	if(Input.is_action_just_pressed("mouse_right_click")):
		# Clear selection
		if(hasSelection):
			# Clear tile states if we had completed the selection
			selectTiles(false)
		hasSelection = false
		isSelecting = false
	
	# TODO: How to track active selection box between first and second click?
	if(hasSelection):
		# Highlight all tiles that are in selection box
		selectTiles(true)


func selectTile(x, z):
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


func _on_tile_hover_enter(x, z):
	isHovering = true
	hoverX = x
	hoverZ = z


func _on_tile_hover_exit(x, z):
	isHovering = false
	hoverX = -1
	hoverZ = -1


func selectTiles(state):
	# TODO: Check indices are valid before loop
	var minX = min(selectStartIndexX, selectEndIndexX)
	var maxX = max(selectStartIndexX, selectEndIndexX)
	var minZ = min(selectStartIndexZ, selectEndIndexZ)
	var maxZ = max(selectStartIndexZ, selectEndIndexZ)
	
	for x in range(minX, maxX + 1):
		for z in range(minZ, maxZ + 1):
			tiles[x][z].selectTile(state)
