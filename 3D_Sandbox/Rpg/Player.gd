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

func _ready():
	if not Engine.is_editor_hint():
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if not Engine.is_editor_hint():
		if Input.is_action_just_pressed("quit"):
			get_tree().quit()
	
		# Mouse Camera rotation
		if event is InputEventMouseMotion:
			spring_arm_pivot.rotate_y(-event.relative.x * 0.005) # Small number due to radians 
			spring_arm.rotate_x(-event.relative.y * 0.005)
			spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/4, PI/4)

func _physics_process(delta):
	if not Engine.is_editor_hint():
		# Add the gravity.
		if not is_on_floor():
			velocity.y -= gravity * delta

		# Handle Jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir = Input.get_vector("control_left", "control_right", "control_forward", "control_back")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		direction = direction.rotated(Vector3.UP, spring_arm_pivot.rotation.y) # Apply movement relative to camera forward
		if direction:
			velocity.x = lerp(velocity.x, direction.x * SPEED, LERP_VAL)
			velocity.z = lerp(velocity.z, direction.z * SPEED, LERP_VAL)
			# atan2 used to get angle in X/Z plane of velocity vector
			armature.rotation.y = lerp_angle(armature.rotation.y, atan2(-velocity.x, -velocity.z), LERP_VAL)
		else:
			velocity.x = lerp(velocity.x, 0.0, LERP_VAL)
			velocity.z = lerp(velocity.z, 0.0, LERP_VAL)
		
		# AnimationTree -> Parameters -> BlendSpace1D -> Copy Property Path
		anim_tree.set("parameters/BlendSpace1D/blend_position", velocity.length() / SPEED)
		
		move_and_slide()
