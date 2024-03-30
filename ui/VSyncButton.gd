extends OptionButton


#manually listing mode names as internall enums are just numbers
enum VSyncModes {
	Disabled,
	Enabled,
	Adaptive,
	Mailbox
}

# Called when the node enters the scene tree for the first time.
func _ready():
	#button_pressed = DisplayServer.window_get_vsync_mode()
	for item in VSyncModes.keys():
		add_item(item)
		
	selected = DisplayServer.window_get_vsync_mode()


func _on_item_selected(index):
	DisplayServer.window_set_vsync_mode(index)
