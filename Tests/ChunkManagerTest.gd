@tool

extends Node3D


@export var add_hotspot : NodePath:
	set(nv):
		chunkmanager.add_hotspot(get_node_or_null(nv))

@export var remove_hotspot : NodePath:
	set(nv):
		chunkmanager.remove_hotspot(get_node_or_null(nv))

@export var print_status : bool = false:
	set(_nv):
		print(get_status_text())

@export var open_data_folder : bool = false:
	set(_nv):
		OS.shell_open(ProjectSettings.globalize_path(chunkmanager.database_folder))


var chunkmanager : ChunkManager


# Called when the node enters the scene tree for the first time.
func _ready():
	chunkmanager = %ChunkManager
	chunkmanager.connect("new_chunk_created", _on_chunk_created)
	chunkmanager.connect("chunk_loaded", _on_chunk_loaded)
	chunkmanager.connect("chunk_activated", _on_chunk_activated)
	chunkmanager.get_chunk_at(Vector3i(0,0,0))


func _on_chunk_created(chunk):
	print("Received 'new_chunk_created' with %s" % chunk)
	var new_debug_mesh = DebugMesh.new(Color(1,0.5,0))
	new_debug_mesh.position = chunk.position
	new_debug_mesh.scale = Vector3i(chunkmanager.chunk_size,chunkmanager.chunk_size,chunkmanager.chunk_size)
	chunk.data["DebugMesh"] = new_debug_mesh
	add_child(new_debug_mesh)


func _on_chunk_loaded(chunk):
	print("Received 'chunk_loaded' with %s" % chunk)
	chunk.data["DebugMesh"].color = Color(0.1,0.1,0.1)


func _on_chunk_activated(chunk):
	print("Received 'chunk_activated' with %s" % chunk)
	chunk.data["DebugMesh"].color = Color(0.1,1.0,0.1)


func get_status_text():
	return "CHUNKSERVER: %s chunks, %s active\n%s hotspots" % [chunkmanager.chunks.size(), chunkmanager.active_chunks, chunkmanager.hotspots.size()]


func _on_update_timer_timeout():
	%StatusLabel.text = get_status_text()
