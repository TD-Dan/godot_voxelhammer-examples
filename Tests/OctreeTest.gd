@tool

extends Node3D

var octree : Octree


# Called when the node enters the scene tree for the first time.
func _ready():
	octree = %Octree
	
	octree.connect("branch_added", _on_branch_added)
	

func _process(delta):
	%MovingTarget.progress_ratio += delta/30.0
	%MovingTarget2.progress_ratio += delta/50.0
	octree.get_branch(%MovingTarget.global_position)


func _on_branch_added(branch):
	#print("Received '_on_branch_added' with %s" % branch)
	if branch.user_data: push_error('OctreeTest: BUG: Found existing branch.user_data!')
	
	var new_debug_mesh = DebugMesh.new(Color(.1, .1, .1, .2))
	branch.user_data = new_debug_mesh
	
	new_debug_mesh.position = branch.position
	new_debug_mesh.scale = Vector3i(branch.size, branch.size, branch.size)
	new_debug_mesh.color = Color(1.0-float(branch.level)/float(octree.levels),float(branch.level)/float(octree.levels),0,0.75)
	
	add_child(new_debug_mesh)


func _on_branch_deleted(branch):
	#print("Received 'chunk_unloaded' with %s" % chunk)
	branch.user_data.color = Color(1., 0., 0., .5)
	remove_child(branch.user_data)
	branch.user_data.queue_free()


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

