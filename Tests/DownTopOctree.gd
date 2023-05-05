@tool

extends Node3D


var _tracking_target : Node3D
@export var tracking_target: NodePath:
	set(nv):
		tracking_target = nv
		_tracking_target = get_node_or_null(nv)
var _target_position : Vector3


class Octree:
	signal leaf_created
	signal leaf_deleted
	var lods : Array
	func _init(lod_levels = 4):
		lods = Array()
		lods.resize(lod_levels)
		lods.fill(Dictionary())
	
	func update(pos : Vector3):
		var n : int = 1
		for lod_content in lods:
			var center_pos = pos# - (Vector3(n,n,n)/2.0)
			var clipped_pos : Vector3i = center_pos.snapped(Vector3(n,n,n))
			
			var found_leaf = lod_content.get(clipped_pos)
			if not found_leaf:
				#for leaf in lod_content.values():
				#	emit_signal("leaf_deleted", leaf)
				#lod_content.clear()
				var new_leaf = DebugMesh.new()
				found_leaf = new_leaf
				new_leaf.position = clipped_pos
				new_leaf.scale = Vector3(n,n,n)
				lod_content[clipped_pos] = new_leaf
				emit_signal("leaf_created", new_leaf)
			else:
				found_leaf.mesh_color = Color(0,1,0)
				return
			
			n *= 2

var tree : Octree = Octree.new(6)


# Called when the node enters the scene tree for the first time.
func _ready():
	var pos = Vector3i(-16,0,0)
	for i in range(32):
		pos.x += 1
		print("%s -> %s" % [pos, pos.snapped(Vector3(4,4,4))])
	
	_tracking_target = get_node_or_null(tracking_target)
	tree.connect("leaf_created", _on_leaf_created)
	tree.connect("leaf_deleted", _on_leaf_deleted)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not _tracking_target: return
	
	_target_position = _tracking_target.global_position
	
	tree.update(_target_position)

func _on_leaf_created(leaf):
	print("Added leaf: %s" % leaf.position)
	add_child.call_deferred(leaf)


func _on_leaf_deleted(leaf):
	print("Removed leaf: %s" % leaf.position)
	remove_child.call_deferred(leaf)
