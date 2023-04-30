extends CharacterBody3D

@onready var armature = $LowPolyCharacter01/Armature
@onready var spring_arm_pivot = $SpringArmPivot
@onready var spring_arm = $SpringArmPivot/SpringArm3D
@onready var anim_tree = $AnimationTree

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const LERP_VAL = 0.15

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var was_on_floor
var dragging
var mouse_pos_on_terrain
var move_direction
var mouse_changed

func _ready():
	pass

func _unhandled_input(event):
	if not Engine.is_editor_hint():
		if Input.is_action_just_pressed("quit"):
			get_tree().quit()
		
		# Mouse Camera rotation	
		if event is InputEventMouseButton:
			if event.is_pressed():
				dragging = true
			else:
				dragging = false

func _physics_process(delta):
	if not Engine.is_editor_hint():
		# Add the gravity.
		if not is_on_floor():
			velocity.y -= gravity * delta

		var grounded_changed = false
		if is_on_floor() != was_on_floor:
			grounded_changed = true
		was_on_floor = is_on_floor()
		
		# Handle Jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Update movement direction when mouse position changes
		# We keep the last direction so that the character will continue to move 
		# 	even once they pass that initial click location
		if(mouse_changed):
			move_direction = (mouse_pos_on_terrain - position).normalized()
			mouse_changed = false
		
		# Handle movement/deceleration with mouse button is down
		if(dragging):
			velocity.x = lerp(velocity.x, move_direction.x * SPEED, LERP_VAL)
			velocity.z = lerp(velocity.z, move_direction.z * SPEED, LERP_VAL)
			# atan2 used to get angle in X/Z plane of velocity vector
			armature.rotation.y = lerp_angle(armature.rotation.y, atan2(-velocity.x, -velocity.z), LERP_VAL)
		else:
			velocity.x = lerp(velocity.x, 0.0, LERP_VAL)
			velocity.z = lerp(velocity.z, 0.0, LERP_VAL)
		
		# AnimationTree -> Parameters -> BlendSpace1D -> Copy Property Path
		anim_tree.set("parameters/Movement/blend_amount", velocity.length() / SPEED)
		anim_tree.set("parameters/Grounded/blend_amount", !is_on_floor())
		if grounded_changed:
			if is_on_floor():
				anim_tree.set("parameters/Landing/request", true)
			else:
				anim_tree.set("parameters/Jumping/request", true)
		
		move_and_slide()

func _on_static_body_3d_input_event(camera, event, position, normal, shape_idx):
	# Note that any object with ray_pickable flag will intercept the terrain detection
	# TODO: Come up with a better way to handle movement input (can we use layers somehow?)
	mouse_pos_on_terrain = position
	mouse_changed = true
