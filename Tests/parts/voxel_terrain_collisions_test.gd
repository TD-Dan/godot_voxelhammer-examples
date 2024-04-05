extends VBoxContainer


func _on_start_test_button_pressed():
	if %Interactive.process_mode == Node.PROCESS_MODE_DISABLED:
		%Interactive.process_mode = Node.PROCESS_MODE_INHERIT
		%StartTestButton.text = "Pause test"
	else:
		%Interactive.process_mode = Node.PROCESS_MODE_DISABLED
		%StartTestButton.text = "Run test"
