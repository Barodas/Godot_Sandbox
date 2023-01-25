extends Spatial

export (PackedScene) var tileScene
export (PackedScene) var villagerScene

var map = [ [1,1,1,1,1,1,1,1,1,1],
			[1,1,1,1,1,1,1,1,1,1],
			[1,1,1,1,1,1,1,1,1,1],
			[1,1,1,1,1,1,1,1,1,1],
			[1,1,1,1,1,1,1,1,1,1],
			[1,1,1,1,1,1,1,1,1,1],
			[1,1,1,1,1,1,1,1,1,1],
			[1,1,1,1,0,0,1,1,1,1],
			[1,1,1,0,0,2,0,1,1,1]]

var tiles = []
var villagers = []

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
	# Seed random number generator
	randomize()
	
	# Generate Terrain Tiles
	for z in map.size():
		tiles.append([])
		for x in map[z].size():
			var instance = tileScene.instance()
			instance.initialise(x, z, 2, map[z][x])
			#instance.connect("tile_clicked", self, "_on_tile_clicked")
			instance.connect("tile_mouse_enter", self, "_on_tile_hover_enter")
			instance.connect("tile_mouse_exit", self, "_on_tile_hover_exit")
			tiles[z].append(instance)
			add_child(instance)
			
			# Create a villager
			if(map[z][x] == 2):
				var villagerInstance = villagerScene.instance()
				villagerInstance.initialise(x, z, 2, self)
				villagers.append(villagerInstance)
				add_child(villagerInstance)


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


func getNearbyEmptyTiles(xPos, zPos):
	var nearbyTiles = []
	for z in range(zPos - 1, zPos + 2):
		for x in range(xPos - 1, xPos + 2):
			#if(z < 0 || z >= tiles.size() || x < 0 || x >= tiles[z].size() || tiles[z][x].getWall()):
			#	continue
			if(z < 0 || z >= tiles.size()):
				print("skip hit z")
				continue
			if(x < 0 || x >= tiles[z].size()):
				print("skip hit x")
				continue
			if(tiles[z][x].getWall()):
				print("skip hit wall")
				continue
			nearbyTiles.append(tiles[z][x])
	return nearbyTiles


func selectTiles(endx, endz, state):
	var minX = min(selectStartIndexX, endx)
	var maxX = max(selectStartIndexX, endx)
	var minZ = min(selectStartIndexZ, endz)
	var maxZ = max(selectStartIndexZ, endz)
	
	for z in range(minZ, maxZ + 1):
		for x in range(minX, maxX + 1):
			tiles[z][x].selectTile(state)
