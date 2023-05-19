extends Control


@export var color_data = Color(0,0,0,0.3)
@export var color_active = Color(0.5,0.5,1,0.3)
@export var color_loaded = Color(0,1,0,0.5)
@export var color_by_chunk_status = false
@export var reverse_view = false

var array_data


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	if array_data._order.is_empty(): return
	
	#draw_line(Vector2(0,size.y),Vector2(array_data.size(),size.y),self.color_axis,1.0)
	var x = 0
	var start = 0
	var end = array_data._order.size()-1
	var iterator_advance = 1
	if reverse_view:
		x = size.x
		start = array_data._order.size()-1
		iterator_advance = -1
		end = 0
	
	var cooloor = color_data
	for i in range(start, end, iterator_advance):
		var data_point = array_data._order[i]
		if color_by_chunk_status:
			if data_point.active: cooloor = color_active
			elif data_point.loaded: cooloor = color_loaded
		
		draw_line(Vector2(x, size.y),Vector2(x,size.y-data_point._sorted_array_key),cooloor,1.0)
		x += iterator_advance

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	queue_redraw()
