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

var previewHover
var prevX
var prevZ


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
		if(previewHover):
			selectTiles(prevX, prevZ, false)
			previewHover = false
		if(hasSelection):
			# Clear tile states if we had completed the selection
			selectTiles(selectEndIndexX, selectEndIndexZ, false)
		hasSelection = false
		isSelecting = false
	
	# Highlight all tiles that are in selection box
	if(hasSelection):
		selectTiles(selectEndIndexX, selectEndIndexZ, true)
	
	# Display expected selection area between first click and current mouse
	if(isSelecting && !hasSelection):
		# Clear previous hover state
		if(previewHover):
			selectTiles(prevX, prevZ, false)
			previewHover = false
		# Select tiles in hover area
		if(!previewHover):
			# If there is no tile hovered, keep the previous valid preview
			if(hoverX != -1 && hoverZ != -1):
				prevX = hoverX
				prevZ = hoverZ
			selectTiles(prevX, prevZ, true)
			previewHover = true


func selectTile(x, z):
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


func selectTiles(endx, endz, state):
	var minX = min(selectStartIndexX, endx)
	var maxX = max(selectStartIndexX, endx)
	var minZ = min(selectStartIndexZ, endz)
	var maxZ = max(selectStartIndexZ, endz)
	
	for x in range(minX, maxX + 1):
		for z in range(minZ, maxZ + 1):
			tiles[x][z].selectTile(state)
