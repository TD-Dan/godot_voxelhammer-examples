extends MenuBar

class SceneEntry:
	var name
	var scene
	func _init(n,s):
		name = n
		scene = s

var examples  = []
var tests  = []

@onready var examples_menu = $Examples
@onready var tests_menu = $Tests
var test_world_root : Node3D
var test_ui_root : Control

# Called when the node enters the scene tree for the first time.
func _ready():
	# connect with main program
	test_world_root = get_node_or_null("%TestWorldRoot")
	test_ui_root = get_node_or_null("%TestUIRoot")
	if not test_world_root:
		push_error("No node with unique name TestWorldRoot!")
	if not test_ui_root:
		push_error("No node with unique name TestUIRoot!")
	
	# autodiscover example scenes
	var dir = DirAccess.open("res://Examples")
	if dir:
		dir.list_dir_begin()
		var filename = dir.get_next()
		while filename != "":
			if filename.ends_with(".tscn"):
				examples.append(SceneEntry.new(filename.get_basename(), load("res://Examples/%s" % filename) ))
			filename = dir.get_next()
	
	# autodiscover test scenes
	dir = DirAccess.open("res://Tests")
	if dir:
		dir.list_dir_begin()
		var filename = dir.get_next()
		while filename != "":
			if filename.ends_with(".tscn"):
				tests.append(SceneEntry.new(filename.get_basename(), load("res://Tests/%s" % filename) ))
			filename = dir.get_next()
	
	# add examples and tests to main menu
	for entry in examples:
		examples_menu.add_item(entry.name)
	for entry in tests:
		tests_menu.add_item(entry.name)


func _on_scene_index_pressed(index):
	var test_scene : Node = tests[index].scene.instantiate()
	_switch_to_scene(test_scene)


func _on_examples_index_pressed(index):
	var example_scene = examples[index].scene.instantiate()
	_switch_to_scene(example_scene)


func _switch_to_scene(scene : Node = null):
	# clear previous scene
	for n in test_world_root.get_children():
		n.queue_free()
	for n in test_ui_root.get_children():
		n.queue_free()
	
	if not scene:
		push_warning("scene is null, only clearing world and ui")
		return
	
	var new_world = scene.get_node_or_null("WORLD")
	var new_ui = scene.get_node_or_null("UI")
	
	if new_world:
		scene.remove_child(new_world)
		test_world_root.add_child(new_world)
	else:
		push_warning("Scene has no Node3D named WORLD")
	
	if new_ui:
		scene.remove_child(new_ui)
		test_ui_root.add_child(new_ui)
	else:
		push_warning("Scene has no Control named UI")

