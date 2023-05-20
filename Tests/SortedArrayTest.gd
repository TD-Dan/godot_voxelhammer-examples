extends Node


var sorted_array = SortedArray.new()

class Sortable:
	var _sorted_array_key : int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	var generated_data = Array()
	var amount = 1000
	for i in range(amount):
		var new_sortable = Sortable.new()
		new_sortable._sorted_array_key = randi_range(0,500)
		generated_data.push_back(new_sortable)
	
	sorted_array.append_array(generated_data)
	
	%SortedArrayView.array_data = sorted_array

var iterator = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	iterator += 1
	if iterator >= sorted_array.size():
		iterator = 0
	
	var new_sortable = Sortable.new()
	new_sortable._sorted_array_key = randi_range(0,500)
	sorted_array.insert(new_sortable)
	
	sorted_array.remove_at(randi_range(0,sorted_array.size()-1))
	
	var ro_array = sorted_array.get_array_for_read_only()
	var sortable = ro_array[iterator]
	sortable._sorted_array_key += randi_range(-100,100)
	sortable._sorted_array_key = clampi(sortable._sorted_array_key,0,500)
	sorted_array.update(sortable)
