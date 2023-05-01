extends Node3D


@export var paint_stack : VoxelPaintStack

# Called when the node enters the scene tree for the first time.
func _ready():
	paint_stack = load("res://Examples/LiveBlobsPaintStack.tres")
	
	for child in get_children():
		child.connect("mesh_ready", _mesh_is_ready.bind(child))
		child.paint_stack = paint_stack

var elapsed = 0.0
var frame_limit = 1.0/2.0
var frame_limit_counter = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	elapsed += delta
	frame_limit_counter += delta
	if frame_limit_counter >= frame_limit:
		frame_limit_counter -= frame_limit
		var phase = (sin(elapsed/2.0)+1.0)/2.0
		print(phase)
		paint_stack.operation_stack[0].plane.y = phase
		for vox_node in get_children():
			vox_node.apply_paintstack()

func _mesh_is_ready(vox_node):
	print("mesh ready for %s" % vox_node)
	#vox_node.apply_paintstack()
