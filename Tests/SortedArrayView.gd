extends Control


@export var color_data = Color(0,0,0,0.3)
@export var color_by_chunk_status = false
@export var reverse_view = false

var array_data


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	if array_data.is_empty(): return
	
	#draw_line(Vector2(0,size.y),Vector2(array_data.size(),size.y),self.color_axis,1.0)
	var x = 0
	var start = 0
	var end = array_data.size()-1
	var iterator_advance = 1
	if reverse_view:
		x = size.x
		start = array_data.size()-1
		iterator_advance = -1
		end = 0
	
	var cooloor = color_data
	var ro_array_data = array_data.get_array_for_read_only()
	for i in range(start, end, iterator_advance):
		var data_point = ro_array_data[i]
		if color_by_chunk_status:
			cooloor = Color(0,0,0,0.1)
			if data_point.loaded:
				cooloor.b = 1.0
				cooloor.a = 0.8
			if data_point.active:
				cooloor.g = 1.0
				cooloor.a = 0.5
		
		draw_line(Vector2(x, size.y),Vector2(x,size.y-data_point._sorted_array_key),cooloor, 1.0)
		x += iterator_advance

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	queue_redraw()
