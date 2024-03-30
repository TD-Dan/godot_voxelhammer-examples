@tool

extends Node3D

var octree : Octree

var branch_count : int = 0

@export var show_debug_meshes = true

var debug_meshes : Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	octree = %Octree
	
	octree.cache_size = 4
	
	octree.connect("branch_added", _on_branch_added)
	
	%SizeSpinBox.value = octree.max_size
	%CacheSpinBox.value = octree.cache_size
	%ToggleDebug.button_pressed = show_debug_meshes
	
	debug_meshes = Node3D.new()
	add_child(debug_meshes)
	

func _process(delta):
	%MovingTarget.progress_ratio += delta/100.0
	%MovingTarget2.progress_ratio += delta/50.0
	octree.get_branch(%TestTarget.global_position)
	octree.get_branch(%TestTarget2.global_position)
	octree.get_branch(%MovingTarget.global_position)
	octree.get_branch(%MovingTarget2.global_position)


func _on_branch_added(branch):
	#print("Received '_on_branch_added' with %s" % branch)
	if branch.user_data: push_error('OctreeTest: BUG: Found existing branch.user_data!')
	
	if show_debug_meshes:
		var new_debug_mesh = DebugMesh.new(Color(.1, .1, .1, .2))
		branch.user_data = new_debug_mesh

		new_debug_mesh.position = branch.position
		new_debug_mesh.scale = Vector3i(branch.size, branch.size, branch.size)
		new_debug_mesh.color = Color(1.0-float(branch.level)/float(octree.levels),float(branch.level)/float(octree.levels),0,0.75)
		
		debug_meshes.add_child(new_debug_mesh)
	
	branch_count += 1


func _on_branch_deleted(branch):
	#print("Received 'chunk_unloaded' with %s" % chunk)
	branch.user_data.color = Color(1., 0., 0., .5)
	remove_child(branch.user_data)
	branch.user_data.queue_free()


func _on_update_timer_timeout():
	%StatusLabel.text = "Octree roots: %s, branches: %s" % [octree.roots.size(), branch_count]


func _on_depth_spin_box_value_changed(value):
	octree.max_size = value
	%SizeSpinBox.set_value_no_signal(octree.max_size)
	octree.clear()
	branch_count = 0
	if show_debug_meshes and debug_meshes != null:
		debug_meshes.queue_free()
		debug_meshes = Node3D.new()
		add_child(debug_meshes)


func _on_cache_spin_box_value_changed(value):
	octree.cache_size = value


func _on_toggle_debug_toggled(button_pressed):
	show_debug_meshes = button_pressed
	if not show_debug_meshes:
		debug_meshes.queue_free()
		debug_meshes = Node3D.new()
		add_child(debug_meshes)
