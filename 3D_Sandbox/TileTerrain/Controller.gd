extends Node

onready var World = get_node("World")
onready var DigButton = get_node("UI/DigOrderButton")
onready var ModeText = get_node("UI/ModeText")
onready var InfoBox = get_node("UI/InfoBox")

enum ClickMode {
	INFO,
	DIG
}

var click_mode = ClickMode.INFO

func _ready():
	# Initialise UI
	update_mode_text()
	DigButton.connect("pressed", self, "_on_dig_button_pressed")

func _process(delta):
	pass

func _input(event):
	if Input.is_action_just_pressed("mouse_left_click"):
		if World.is_hovering:
			match click_mode:
				ClickMode.INFO:
					pass
				ClickMode.DIG:
					World.select_hovered_tile()
	
	if Input.is_action_just_pressed("mouse_right_click"):
		World.clear_selection()

func _on_dig_button_pressed():
	World.clear_selection()
	match click_mode:
		ClickMode.INFO:
			click_mode = ClickMode.DIG
		ClickMode.DIG:
			click_mode = ClickMode.INFO
	update_mode_text()

func update_mode_text():
	ModeText.text = "Mode: {}".format([click_mode], "{}")

func update_info_box():
	InfoBox.text = "Tile Info: \n"
