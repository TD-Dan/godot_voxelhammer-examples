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
	
	chunkmanager.connect("chunk_initialized", _on_chunk_initialized)
	chunkmanager.connect("new_chunk_created", _on_chunk_created)
	chunkmanager.connect("chunk_loaded", _on_chunk_loaded)
	chunkmanager.connect("chunk_activated", _on_chunk_activated)
	chunkmanager.connect("chunk_deactivated", _on_chunk_deactivated)
	chunkmanager.connect("chunk_unloaded", _on_chunk_unloaded)
	chunkmanager.connect("chunk_deleted", _on_chunk_deleted)
	chunkmanager.connect("shortest_distance_updated", _on_shortest_distance_updated)
	
	chunkmanager.add_hotspot(%TestTarget)
	chunkmanager.add_hotspot(%TestTarget2)
	chunkmanager.add_hotspot(%MovingTarget)
	chunkmanager.add_hotspot(%MovingTarget2)
	
	%SortedArrayView.array_data = chunkmanager.chunks_by_distance

func _process(delta):
	%MovingTarget.progress_ratio += delta/200.0
	%MovingTarget2.progress_ratio += delta/50.0


func _on_chunk_initialized(chunk : Chunk):
	#print("Received 'chunk_initialized' with %s" % chunk)
	
	if chunk.transient_data.has("DebugMesh"):
		push_error('ChunkMnagerTest: Found existing chunk.transient_data["DebugMesh"]!')
		
	var new_debug_mesh = DebugMesh.new(Color(.1, .1, .1, .2))
	
	new_debug_mesh.position = chunk.position
	new_debug_mesh.scale = Vector3i(chunkmanager.chunk_size,chunkmanager.chunk_size,chunkmanager.chunk_size)
	new_debug_mesh.text += "initialized at %s\n" % Time.get_datetime_string_from_system()
	
	chunk.transient_data["DebugMesh"] = new_debug_mesh
	add_child(new_debug_mesh)


func _on_chunk_created(chunk: Chunk):
	#print("Received 'new_chunk_created' with %s" % chunk)
	if not chunk.transient_data.has("DebugMesh"):
		var new_debug_mesh = DebugMesh.new()
		new_debug_mesh.position = chunk.position
		new_debug_mesh.scale = Vector3i(chunkmanager.chunk_size,chunkmanager.chunk_size,chunkmanager.chunk_size)
		chunk.transient_data["DebugMesh"] = new_debug_mesh
		add_child(new_debug_mesh)
	
	chunk.transient_data["DebugMesh"].color = Color(.1, .1, .5, .2)
	chunk.transient_data["DebugMesh"].text += "created at %s\n" % Time.get_datetime_string_from_system()
	
	chunk.persistent_data["BytesData"] = PackedByteArray()
	chunk.persistent_data["BytesData"].resize(64*64*64)
	chunk.persistent_data["BytesData"].fill(2)
	
	chunk.persistent_data["Counter"] = 0
	
	chunk.data_changed = true


func _on_chunk_loaded(chunk : Chunk):
	#print("Received 'chunk_loaded' with %s" % chunk)
	if not chunk.transient_data.has("DebugMesh"):
		var new_debug_mesh = DebugMesh.new()
		new_debug_mesh.position = chunk.position
		new_debug_mesh.scale = Vector3i(chunkmanager.chunk_size,chunkmanager.chunk_size,chunkmanager.chunk_size)
		chunk.transient_data["DebugMesh"] = new_debug_mesh
		add_child(new_debug_mesh)
		
	chunk.transient_data["DebugMesh"].color = Color(.4, .4, .8, .8)
	chunk.transient_data["DebugMesh"].text += "loaded at %s\n" % Time.get_datetime_string_from_system()


func _on_chunk_activated(chunk : Chunk):
	#print("Received 'chunk_activated' with %s" % chunk)
	
	chunk.persistent_data["Counter"] += 1
	chunk.data_changed = true
	
	
	chunk.transient_data["DebugMesh"].color = Color(.1, 1.0, .1, 1.0)
	chunk.transient_data["DebugMesh"].text += "Activated at %s\n" % Time.get_datetime_string_from_system()
	
	
	chunk.transient_data["CounterLabel"] = Label3D.new()
	chunk.transient_data["CounterLabel"].text = "saved value:%s" % chunk.persistent_data["Counter"]
	chunk.transient_data["CounterLabel"].pixel_size = 0.001
	chunk.transient_data["CounterLabel"].modulate = chunk.transient_data["DebugMesh"].color
	chunk.transient_data["CounterLabel"].position.y = 0.5
	chunk.transient_data["CounterLabel"].vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	chunk.transient_data["CounterLabel"].horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	
	chunk.transient_data["DebugMesh"].add_child(chunk.transient_data["CounterLabel"])

func _on_chunk_deactivated(chunk : Chunk):
	#print("Received 'chunk_deactivated' with %s" % chunk)
	chunk.transient_data["DebugMesh"].color = Color(.4, .4, .8, .8)
	chunk.transient_data["DebugMesh"].text += "Deactivated at %s \n" % Time.get_datetime_string_from_system()
	chunk.transient_data["CounterLabel"].queue_free()
	chunk.transient_data.erase("CounterLabel")


func _on_chunk_unloaded(chunk : Chunk):
	#print("Received 'chunk_unloaded' with %s" % chunk)
	chunk.transient_data["DebugMesh"].text = ""
	chunk.transient_data["DebugMesh"].color = Color(.1, .1, .1, .2)


func _on_chunk_deleted(chunk : Chunk):
	#print("Received 'chunk_unloaded' with %s" % chunk)
	chunk.transient_data["DebugMesh"].color = Color(1., 0., 0., .5)
	remove_child(chunk.transient_data["DebugMesh"])
	chunk.transient_data["DebugMesh"].queue_free()


func _on_shortest_distance_updated(chunk : Chunk):
	#print("Received 'shortest_distance_updated' with %s" % chunk)
	if not chunk.transient_data.has("DebugMesh"): return
	
	if not chunk.transient_data.has("DistanceLabel"):
		chunk.transient_data["DistanceLabel"] = Label3D.new()
		chunk.transient_data["DistanceLabel"].vertical_alignment = VERTICAL_ALIGNMENT_TOP
		chunk.transient_data["DistanceLabel"].horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		chunk.transient_data["DistanceLabel"].pixel_size = 0.001
		chunk.transient_data["DistanceLabel"].position.y = 0.5
		chunk.transient_data["DistanceLabel"].modulate = chunk.transient_data["DebugMesh"].color
		chunk.transient_data["DebugMesh"].add_child(chunk.transient_data["DistanceLabel"])
	chunk.transient_data["DistanceLabel"].text = "%d.1" % chunk.dist_to_closest_hotspot


func get_status_text():
	return "CHUNKSERVER: %s/%s chunks by position/distance, %s loaded, %s active\n%s hotspots" %\
		[chunkmanager.chunks_by_position.size(), chunkmanager.chunks_by_distance.size(), chunkmanager.loaded_chunks.size(),\
		chunkmanager.active_chunks.size(), chunkmanager.hotspots.size()]


func _on_update_timer_timeout():
	%StatusLabel.text = get_status_text()
