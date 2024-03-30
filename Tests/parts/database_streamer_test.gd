extends VBoxContainer


func _on_save_button_pressed():
	%DatabaseStreamer.save_all_to_disk()


func _on_load_button_pressed():
	%DatabaseStreamer.load_all_from_disk()
