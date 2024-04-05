@tool

extends Node


@export var chunk_space : ChunkSpace3D


@export var add_hotspot : NodePath:
	set(nv):
		chunk_space.add_hotspot(get_node_or_null(nv))

@export var remove_hotspot : NodePath:
	set(nv):
		chunk_space.remove_hotspot(get_node_or_null(nv))


@export var show_debug_boxes : bool = true:
	set(nv):
		show_debug_boxes = nv
		#print("Changed to %s" % show_debug_boxes)
		if not show_debug_boxes and is_inside_tree():
			for child in get_children():
				child.queue_free()


@export var print_status : bool = false:
	set(_nv):
		print(get_status_text())


# Chunk3D : DebugMesh
var _debug_boxes : Dictionary = {}


func _ready():
	chunk_space.chunk_added.connect(_on_chunk_added)
	chunk_space.chunk_removed.connect(_on_chunk_removed)
	
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
		[chunk_space.chunks_by_position.size(), chunk_space.hotspots.size()]


func _on_chunk_added(chunk : Chunk3D):
	#print("chunk added: %s: pos %s / size %s" % [chunk, chunk.chunk_position, chunk.chunk_size])
	if show_debug_boxes:
		var new_dbox = DebugMesh.new()
		new_dbox.position = chunk.chunk_position * chunk_space.chunk_size
		new_dbox.size = chunk.chunk_size
		new_dbox.color = Color(0.1, 1.0, 0.2)
		
		_debug_boxes[chunk] = new_dbox
		add_child(new_dbox)


func _on_chunk_removed(chunk : Chunk3D):
	if not show_debug_boxes: return
	
	if chunk in _debug_boxes:
		remove_child(_debug_boxes[chunk])
		_debug_boxes[chunk].queue_free()
		_debug_boxes.erase(chunk)


func _on_update_timer_timeout():
	%StatusLabel.text = get_status_text()
