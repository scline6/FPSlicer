tool
extends Area

export(Vector2)  var Screen_Size     = Vector2(10.0, 15.0) setget set_screen_size,     get_screen_size
export(String)   var Viewport_Name   = "Viewport"          setget set_viewport_name,   get_viewport_name
export(Material) var Screen_Material = null                setget set_screen_material, get_screen_material


# Member variables
var prev_pos = null
var last_click_pos = null
var viewport = null


func set_screen_size(new_screen_size):
	if new_screen_size != Screen_Size:
		Screen_Size = new_screen_size
		$QuadSurface.mesh.set_size(Screen_Size)
		$CollisionBox.shape.set_extents(0.5 * Vector3(Screen_Size.x, Screen_Size.y, 0.01))


func get_screen_size():
	return Screen_Size


func set_viewport_name(new_viewport_name):
	if new_viewport_name != Viewport_Name:
		Viewport_Name = new_viewport_name


func get_viewport_name():
	return Viewport_Name


func set_screen_material(new_screen_material):
	if $QuadSurface == null:
		return
	if new_screen_material != $QuadSurface.material_override:
		Screen_Material = new_screen_material
		$QuadSurface.material_override = Screen_Material


func get_screen_material():
	return Screen_Material


func _input(event):
	# Check if the event is a non-mouse event
	var is_mouse_event = false
	var mouse_events = [InputEventMouseButton, InputEventMouseMotion, InputEventScreenDrag, InputEventScreenTouch]
	for mouse_event in mouse_events:
		if event is mouse_event:
			is_mouse_event = true
			break
	# If it is, then pass the event to the viewport
	if is_mouse_event == false:
		self.viewport.input(event)


# Mouse events for Area
func _on_area_input_event(_camera, event, click_pos, _click_normal, _shape_idx):
	# Use click pos (click in 3d space, convert to area space)
	#print("_on_area_input_event")
	var pos = self.get_global_transform().affine_inverse()
	# the click pos is not zero, then use it to convert from 3D space to area space
	if click_pos.x != 0 or click_pos.y != 0 or click_pos.z != 0:
		pos *= click_pos
		last_click_pos = click_pos
	else:
		# Otherwise, we have a motion event and need to use our last click pos
		# and move it according to the relative position of the event.
		# NOTE: this is not an exact 1-1 conversion, but it's pretty close
		pos *= last_click_pos
		if event is InputEventMouseMotion or event is InputEventScreenDrag:
			pos.x += event.relative.x / self.viewport.size.x
			pos.y += event.relative.y / self.viewport.size.y
			last_click_pos = pos
  
	# Convert to 2D
	pos = Vector2(pos.x, pos.y)
	
	# Convert to viewport coordinate system
	# Convert pos to a range from (0 - 1)
	var qssize = $QuadSurface.mesh.get_size()
	pos.x = self.viewport.size.x * (0.5 * qssize.x + pos.x) / qssize.x
	pos.y = self.viewport.size.y * (0.5 * qssize.y - pos.y) / qssize.y

	# Set the position in event
	event.position = pos
	event.global_position = pos
	if not prev_pos:
		prev_pos = pos
	if event is InputEventMouseMotion:
		event.relative = pos - prev_pos
	prev_pos = pos
	
	# Send the event to the viewport
	self.viewport.input(event)


func _ready():
	self.viewport = self.get_tree().get_root().find_node(Viewport_Name, true, false)
	self.connect("input_event", self, "_on_area_input_event")
  
