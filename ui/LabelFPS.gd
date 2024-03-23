extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var max_delta = 0.0
var refresh_limit = 1.0
var refresh_limit_counter = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if delta > max_delta:
		max_delta = delta
	refresh_limit_counter += delta
	
	if refresh_limit_counter >= refresh_limit:
		refresh_limit_counter -= refresh_limit
		
		text = str(Engine.get_frames_per_second()).lpad(4)
		if max_delta > 0:
			text += " / %4d" % int(1.0/max_delta)
		
		max_delta = 0.0
