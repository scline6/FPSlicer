extends ScrollContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	self.scroll_vertical_enabled = true
	self.scroll_horizontal_enabled = true
	self.set_h_scroll(1)
	self.set_v_scroll(1)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
