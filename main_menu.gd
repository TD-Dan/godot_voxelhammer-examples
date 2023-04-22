extends MenuBar

class SceneEntry:
	var name
	var scene
	func _init(n,s):
		name = n
		scene = s

var scenes  = [
	SceneEntry.new("Voxel", load("res://Tests/single_VoxelInstance3D.tscn")),
	SceneEntry.new("Voxels", load("res://Tests/multiple_instances.tscn")),
	SceneEntry.new("Voxel meshing", load("res://Tests/meshing.tscn")),
	SceneEntry.new("Voxel live instances", load("res://Tests/live_instances.tscn")),
	SceneEntry.new("Voxel multiple duplicates", load("res://Tests/multiple_duplicates.tscn")),
	SceneEntry.new("VoxelPaint", load("res://Tests/VoxelPaint.tscn")),
	SceneEntry.new("VoxelPaintStack", load("res://Tests/PaintStack.tscn")),
	SceneEntry.new("VoxelPaintStack Global", load("res://Tests/PaintStack_global.tscn")),
	SceneEntry.new("Voxel Scaling", load("res://Tests/voxel_scale.tscn")),
	SceneEntry.new("VoxelTerrain", load("res://Tests/VoxelTerrain.tscn"))
]

@onready var scene_menu = $Scene
var test_world : Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	test_world = get_node_or_null("%TestWorld")
	if test_world:
		print("Found TestWorld!")
	else:
		print("Creating TestWorld!")
		test_world = Node3D.new()
		get_parent().add_child.call_deferred(test_world)
	
	for entry in scenes:
		print(entry.name)
		scene_menu.add_item(entry.name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_scene_index_pressed(index):
	# clear previous scene
	for n in test_world.get_children():
		n.queue_free()
	test_world.add_child(scenes[index].scene.instantiate())
	

