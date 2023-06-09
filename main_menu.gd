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
	
	# autodiscover example scenes
	var dir = DirAccess.open("res://Examples")
	if dir:
		dir.list_dir_begin()
		var filename = dir.get_next()
		while filename != "":
			if filename.ends_with(".tscn"):
				examples.append(SceneEntry.new(filename.to_pascal_case().get_basename(), load("res://Examples/%s" % filename) ))
			filename = dir.get_next()
	
	# autodiscover test scenes
	dir = DirAccess.open("res://Tests")
	if dir:
		dir.list_dir_begin()
		var filename = dir.get_next()
		while filename != "":
			if filename.ends_with(".tscn"):
				tests.append(SceneEntry.new(filename.to_pascal_case().get_basename(), load("res://Tests/%s" % filename) ))
			filename = dir.get_next()
	
			
	
	# add to main menu
	for entry in examples:
		#print(entry.name)
		examples_menu.add_item(entry.name)
	for entry in tests:
		#print(entry.name)
		tests_menu.add_item(entry.name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_scene_index_pressed(index):
	# clear previous scene
	for n in test_world.get_children():
		n.queue_free()
	test_world.add_child(tests[index].scene.instantiate())


func _on_examples_index_pressed(index):
	# clear previous scene
	for n in test_world.get_children():
		n.queue_free()
	test_world.add_child(examples[index].scene.instantiate())
