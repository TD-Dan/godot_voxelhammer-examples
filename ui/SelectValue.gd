extends OptionButton

var _target_node : NodePath
@export var target_node : NodePath:
	set(nv):
		_target_node = nv
		_custom_path = ""
		notify_property_list_changed()
	get:
		return _target_node

## f.ex. "/root/MyAutoLoadObject"
var _custom_path : String
@export var custom_path : String:
	set(nv):
		_custom_path = nv
		_target_node = NodePath()
		notify_property_list_changed()
	get:
		return _custom_path

## f.ex. "visible", "variable.sub_variable"
@export var enum_variable_name : String

## f.ex. "VoxelConfiguration.MESH_MODE"
@export var enum_class : String

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("item_selected", _on_item_selected)
	
	var tnode = get_node_or_null(_target_node)
	if not tnode:
		tnode = get_node_or_null(_custom_path)
	
	if tnode:
		var items = ClassDB.class_get_enum_constants(enum_class.rsplit(".")[0], enum_class.rsplit(".")[1])
		
		if not items.is_empty():
			for item in items:
				add_item(item)
		else:
			# Have to do this stupid match as it seems that ClassDB does not know about custom classes
			match enum_class:
				"VoxelConfiguration.MESH_MODE":
					for item in VoxelConfiguration.MESH_MODE:
						add_item(item)
				"VoxelConfiguration.THREAD_MODE":
					for item in VoxelConfiguration.THREAD_MODE:
						add_item(item)
		
		for subpart in enum_variable_name.rsplit("."):
			tnode = tnode.get(subpart)
		
		var selection = tnode
		self.select(selection)
		
	else:
		disabled = true

func _on_item_selected(indx):
	print("selected")
	
	var tnode = get_node_or_null(_target_node)
	if not tnode:
		tnode = get_node_or_null(_custom_path)
	
	var dot_path = enum_variable_name.rsplit(".")
	var variable = dot_path[-1]
	dot_path.remove_at(dot_path.size()-1)
	#print(dot_path)
	#print(variable)
	
	for subpart in dot_path:
		tnode = tnode.get(subpart)
	
	#print(tnode)
	
	tnode.set(variable,indx)
	
