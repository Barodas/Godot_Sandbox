extends Node3D

@export (PackedScene) var tile_scene
@export (PackedScene) var villager_scene

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

var is_hovering
var hover_x
var hover_z

var is_selecting
var has_selection
var select_start_x
var select_start_z
var select_end_x
var select_end_z

var preview_hover
var preview_x
var preview_z

func _ready():
	# Seed random number generator
	randomize()
	
	# Generate Terrain Tiles
	for z in map.size():
		tiles.append([])
		for x in map[z].size():
			var instance = tile_scene.instantiate()
			instance.initialise(x, z, 2, map[z][x])
			instance.connect("tile_mouse_enter", Callable(self, "_on_tile_hover_enter"))
			instance.connect("tile_mouse_exit", Callable(self, "_on_tile_hover_exit"))
			tiles[z].append(instance)
			add_child(instance)
			
			# Create a villager
			if(map[z][x] == 2):
				var villagerInstance = villager_scene.instantiate()
				villagerInstance.initialise(x, z, 2)
				villagers.append(villagerInstance)
				add_child(villagerInstance)

func _process(delta):
	# Highlight all tiles that are in selection box
	if(has_selection):
		select_tiles(select_end_x, select_end_z, true)
	
	# Display expected selection area between first click and current mouse
	if(is_selecting && !has_selection):
		# Clear previous hover state
		if(preview_hover):
			select_tiles(preview_x, preview_z, false)
			preview_hover = false
		# Select tiles in hover area
		if(!preview_hover):
			# If there is no tile hovered, keep the previous valid preview
			if(hover_x != -1 && hover_z != -1):
				preview_x = hover_x
				preview_z = hover_z
			select_tiles(preview_x, preview_z, true)
			preview_hover = true

func _on_tile_hover_enter(x, z):
	is_hovering = true
	hover_x = x
	hover_z = z

func _on_tile_hover_exit(x, z):
	is_hovering = false
	hover_x = -1
	hover_z = -1

func select_tile(x, z):
	if(!has_selection):
		if(!is_selecting):
			# Start Selection
			is_selecting = true
			select_start_x = x
			select_start_z = z
		else:
			# Finish Selection
			is_selecting = false
			has_selection = true
			select_end_x = x
			select_end_z = z

func select_hovered_tile():
	select_tile(hover_x, hover_z)

func select_tiles(endx, endz, state):
	var minX = min(select_start_x, endx)
	var maxX = max(select_start_x, endx)
	var minZ = min(select_start_z, endz)
	var maxZ = max(select_start_z, endz)
	
	for z in range(minZ, maxZ + 1):
		for x in range(minX, maxX + 1):
			tiles[z][x].select_tile(state)

func clear_selection():
	if(preview_hover):
		select_tiles(preview_x, preview_z, false)
		preview_hover = false
	if(has_selection):
		# Clear tile states if we had completed the selection
		select_tiles(select_end_x, select_end_z, false)
	has_selection = false
	is_selecting = false

func get_nearby_empty_tiles(xPos, zPos):
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
			if(tiles[z][x].get_wall()):
				print("skip hit wall")
				continue
			nearbyTiles.append(tiles[z][x])
	return nearbyTiles
