extends Button

## Advanced button to easily set up toggling selected property inside an object

var _target_node : NodePath
@export var target_node : NodePath:
	set(nv):
		_target_node = nv
		_custom_path = ""
		notify_property_list_changed()
	get:
		return _target_node

var _custom_path : String
@export var custom_path : String:
	set(nv):
		_custom_path = nv
		_target_node = NodePath()
		notify_property_list_changed()
	get:
		return _custom_path

@export var bool_variable_name : String

# Called when the node enters the scene tree for the first time.
func _ready():
	var tnode = get_node_or_null(_target_node)
	if not tnode:
		tnode = get_node_or_null(_custom_path)
	if tnode:
		var state : bool = tnode.get(bool_variable_name)
		self.button_pressed = state
	else:
		disabled = true


func _toggled(_button_pressed):
	var tnode = get_node_or_null(_target_node)
	if not tnode:
		tnode = get_node_or_null(_custom_path)
	if tnode:
		tnode.set(bool_variable_name, _button_pressed)
