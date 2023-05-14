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
	chunkmanager.connect("chunk_deactivated", _on_chunk_deactivated)
	chunkmanager.connect("chunk_unloaded", _on_chunk_unloaded)
	chunkmanager.get_chunk_at(Vector3i(0,0,0))
	chunkmanager.add_hotspot(%MovingTarget)
	chunkmanager.add_hotspot(%MovingTarget2)


func _process(delta):
	%MovingTarget.progress_ratio += delta/50.0
	%MovingTarget2.progress_ratio += delta/25.0

func _on_chunk_created(chunk: Chunk):
	print("Received 'new_chunk_created' with %s" % chunk)
	chunk.persistent_data["BytesData"] = PackedByteArray()
	chunk.persistent_data["BytesData"].resize(64*64*64)
	chunk.persistent_data["BytesData"].fill(2)
	chunk.data_changed = true


func _on_chunk_loaded(chunk):
	print("Received 'chunk_loaded' with %s" % chunk)
	var new_debug_mesh = DebugMesh.new(Color(1,0.5,0))
	new_debug_mesh.position = chunk.position
	new_debug_mesh.scale = Vector3i(chunkmanager.chunk_size,chunkmanager.chunk_size,chunkmanager.chunk_size)
	new_debug_mesh.color = Color(0.1,0.1,0.1)
	new_debug_mesh.text = "loaded at "+Time.get_datetime_string_from_system()
	chunk.transient_data["DebugMesh"] = new_debug_mesh
	add_child(new_debug_mesh)


func _on_chunk_activated(chunk):
	print("Received 'chunk_activated' with %s" % chunk)
	chunk.transient_data["DebugMesh"].color = Color(0.1,1.0,0.1)
	chunk.transient_data["DebugMesh"].text += "\nActivated at "+Time.get_datetime_string_from_system()


func _on_chunk_deactivated(chunk):
	print("Received 'chunk_deactivated' with %s" % chunk)
	chunk.transient_data["DebugMesh"].color = Color(0.1,0.1,0.5)


func _on_chunk_unloaded(chunk):
	print("Received 'chunk_unloaded' with %s" % chunk)
	chunk.transient_data["DebugMesh"].color = Color(1,0,0)
	chunk.transient_data["DebugMesh"].queue_free()


func get_status_text():
	return "CHUNKSERVER: %s chunks, %s active\n%s hotspots" % [chunkmanager.chunks.size(), chunkmanager.active_chunks.size(), chunkmanager.hotspots.size()]


func _on_update_timer_timeout():
	%StatusLabel.text = get_status_text()
