extends Node


func _ready():
	# TODO add main camera to ChunkSpace3D as hotspot for tracking
	var player_camera = get_tree().get_first_node_in_group("PlayerCamera")
	if player_camera:
		%VoxelTerrain3D.get_node("ChunkSpace3D").add_hotspot(player_camera)
	else:
		push_error("%s: Cant find player camera node. Should be assigned into group 'PlayerCamera'.")
