@tool

extends Node

@export var chunk_space : ChunkSpace3D

@export var add_hotspot : NodePath:
	set(nv):
		chunk_space.add_hotspot(get_node_or_null(nv))

@export var remove_hotspot : NodePath:
	set(nv):
		chunk_space.remove_hotspot(get_node_or_null(nv))

@export var print_status : bool = false:
	set(_nv):
		print(get_status_text())


func _ready():
	chunk_space.chunk_added.connect(_on_chunk_added)
	
	if not Engine.is_editor_hint():
		chunk_space.add_hotspot(%TestTarget)
		chunk_space.add_hotspot(%TestTarget2)
		chunk_space.add_hotspot(%MovingTarget)
		chunk_space.add_hotspot(%MovingTarget2)


func _process(delta):
	%MovingTarget.progress_ratio += delta/200.0
	%MovingTarget2.progress_ratio += delta/50.0

	%StatusLabel.text = get_status_text()


func get_status_text():
	return "ChunkSpace3D: %s chunks \n%s hotspots" % \
		[chunk_space.chunks_by_position.size(), chunk_space._hotspots.size()]


func _on_chunk_added(chunk : Chunk3D):
	print("chunk added: %s: pos %s / size %s" % [chunk, chunk.chunk_position, chunk.chunk_size])
	var new_debug = DebugMesh.new()
	new_debug.position = chunk.chunk_position * chunk_space.chunk_size
	new_debug.size = chunk.chunk_size
	new_debug.color = Color(0.1, 1.0, 0.2)
	add_child(new_debug)


func _on_update_timer_timeout():
	%StatusLabel.text = get_status_text()
