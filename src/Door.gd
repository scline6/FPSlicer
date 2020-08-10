tool
extends Spatial


export(Vector3)  var Door_Size      = Vector3(80.0, 200.0, 6.0) setget set_door_size,       get_door_size
export(float)    var Knob_Diameter  = 7.5                       setget set_knob_diameter,   get_knob_diameter
export(int)      var Knob_Location  = 1                         setget set_knob_location,   get_knob_location
export(Material) var Panel_Material = null                      setget set_panel_material,  get_panel_material
export(Material) var Knob_Material  = null                      setget set_knob_material,   get_knob_material




func is_null():
	if self.get_child_count() == 0:
		return true
	else:
		for i in range(0, self.get_child_count()):
			if self.get_child(i) == null:
				return true
		return false


func redraw():
	$Spatial/Panel.set_box_size(Vector3(Door_Size.x, Door_Size.z, Door_Size.y))
	var x = 0.0
	if Knob_Location == 1 or Knob_Location == 3:
		x = -0.5 * Door_Size.x + 0.75 * Knob_Diameter
	elif Knob_Location == 2 or Knob_Location == 4:
		x = +0.5 * Door_Size.x - 0.75 * Knob_Diameter
	var z = 0.0
	if Knob_Location == 1 or Knob_Location == 2:
		z = -0.1 * Door_Size.y
	elif Knob_Location == 3 or Knob_Location == 4:
		z = +0.1 * Door_Size.y
	$Spatial/Rod.set_translation(Vector3(x, 0.0, z))
	$Spatial/Rod.set_cylinder_height(2.4 * Door_Size.z)
	$Spatial/Rod.set_bottom_radius(0.2 * Knob_Diameter)
	$Spatial/Rod.set_top_radius(0.2 * Knob_Diameter)
	$Spatial/Knob1.set_translation(Vector3(x, -1.2 * Door_Size.z, z))
	$Spatial/Knob1.set_ball_radius(0.5 * Knob_Diameter)
	$Spatial/Knob1.set_ball_height(0.2 * Knob_Diameter)
	$Spatial/Knob2.set_translation(Vector3(x,  1.2 * Door_Size.z, z))
	$Spatial/Knob2.set_ball_radius(0.5 * Knob_Diameter)
	$Spatial/Knob2.set_ball_height(0.2 * Knob_Diameter)
	$Spatial.set_rotation(Vector3(1.5*PI, 0.0, 0.0))
	$Spatial.set_translation(Vector3(0.0, 0.5 * Door_Size.y, 0.0))


func set_door_size(new_door_size):
	if self.is_null():
		return
	if new_door_size != Door_Size:
		Door_Size = new_door_size
		self.redraw()


func get_door_size():
	return Door_Size


func set_knob_diameter(new_knob_diameter):
	if self.is_null():
		return
	if new_knob_diameter != Knob_Diameter:
		Knob_Diameter = new_knob_diameter
		self.redraw()


func get_knob_diameter():
	return Knob_Diameter


func set_knob_location(new_knob_location):
	if self.is_null():
		return
	if new_knob_location != Knob_Location:
		Knob_Location = new_knob_location
		self.redraw()


func get_knob_location():
	return Knob_Location


func set_panel_material(new_panel_material):
	if self.is_null():
		return
	if new_panel_material != Panel_Material:
		Panel_Material = new_panel_material
		$Spatial/Panel.set_surface_material(Panel_Material)


func get_panel_material():
	return Panel_Material


func set_knob_material(new_knob_material):
	if self.is_null():
		return
	if new_knob_material != Knob_Material:
		Knob_Material = new_knob_material
		$Spatial/Rod.set_surface_material(Knob_Material)
		$Spatial/Knob1.set_surface_material(Knob_Material)
		$Spatial/Knob2.set_surface_material(Knob_Material)


func get_knob_material():
	return Knob_Material



