extends TextEdit


func _on_data_changed():
	get_node("Streamable").notify_stream_data_changed()
