@tool

extends Node

@export var chunkmanager : ChunkSpace3D

@export var add_hotspot : NodePath:
	set(nv):
		chunkmanager.add_hotspot(get_node_or_null(nv))

@export var remove_hotspot : NodePath:
	set(nv):
		chunkmanager.remove_hotspot(get_node_or_null(nv))

@export var print_status : bool = false:
	set(_nv):
		print(get_status_text())


func _ready():
	chunkmanager = %ChunkManager
	
	chunkmanager.add_hotspot(%TestTarget)
	chunkmanager.add_hotspot(%TestTarget2)
	chunkmanager.add_hotspot(%MovingTarget)
	chunkmanager.add_hotspot(%MovingTarget2)
	
	%SortedArrayView.array_data = chunkmanager.chunks_by_distance


func _process(delta):
	%MovingTarget.progress_ratio += delta/200.0
	%MovingTarget2.progress_ratio += delta/50.0


func get_status_text():
	return "CHUNKSERVER: %s/%s chunks by position/distance, %s loaded, %s active\n%s hotspots" %\
		[chunkmanager.chunks_by_position.size(), chunkmanager.chunks_by_distance.size(), chunkmanager.loaded_chunks.size(),\
		chunkmanager.active_chunks.size(), chunkmanager.hotspots.size()]


func _on_update_timer_timeout():
	%StatusLabel.text = get_status_text()
