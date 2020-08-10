tool
extends Spatial


export(Vector3)  var Table_Size    = Vector3(150.0, 75.0, 50.0) setget set_table_size,    get_table_size
export           var Top_Thickness = 5.0                        setget set_top_thickness, get_top_thickness
export           var Leg_Diameter  = 7.5                        setget set_leg_diameter,  get_leg_diameter
export(Material) var Top_Material  = null                       setget set_top_material,  get_top_material
export(Material) var Leg_Material  = null                       setget set_leg_material,  get_leg_material


func is_null():
	if self.get_child_count() == 0:
		return true
	else:
		for i in range(0, self.get_child_count()):
			if self.get_child(i) == null:
				return true
		return false


func redraw():
	$Top.set_translation(Vector3(0.0, -0.5 * Top_Thickness, 0.0))
	$Top.set_box_size(Vector3(Table_Size.x, Top_Thickness, Table_Size.z))
	var y = -0.5 * Top_Thickness - 0.5 * Table_Size.y
	var x = -0.5 * Table_Size.x + Leg_Diameter
	var z = -0.5 * Table_Size.z + Leg_Diameter
	$Leg1.set_translation(Vector3(x, y, z))
	x = -0.5 * Table_Size.x + Leg_Diameter
	z =  0.5 * Table_Size.z - Leg_Diameter
	$Leg2.set_translation(Vector3(x, y, z))
	x =  0.5 * Table_Size.x - Leg_Diameter
	z = -0.5 * Table_Size.z + Leg_Diameter
	$Leg3.set_translation(Vector3(x, y, z))
	x =  0.5 * Table_Size.x - Leg_Diameter
	z =  0.5 * Table_Size.z - Leg_Diameter
	$Leg4.set_translation(Vector3(x, y, z))
	var h = Table_Size.y - Top_Thickness
	var r = 0.5 * Leg_Diameter
	$Leg1.set_cylinder_height(h)
	$Leg1.set_bottom_radius(r)
	$Leg1.set_top_radius(r)
	$Leg2.set_cylinder_height(h)
	$Leg2.set_bottom_radius(r)
	$Leg2.set_top_radius(r)
	$Leg3.set_cylinder_height(h)
	$Leg3.set_bottom_radius(r)
	$Leg3.set_top_radius(r)
	$Leg4.set_cylinder_height(h)
	$Leg4.set_bottom_radius(r)
	$Leg4.set_top_radius(r)


func set_table_size(new_table_size):
	if self.is_null():
		return
	if new_table_size != Table_Size:
		Table_Size = new_table_size
		self.redraw()


func get_table_size():
	return Table_Size


func set_top_thickness(new_top_thickness):
	if self.is_null():
		return
	if new_top_thickness != Top_Thickness:
		Top_Thickness = new_top_thickness
		self.redraw()


func get_top_thickness():
	return Top_Thickness
	
	
func set_leg_diameter(new_leg_diameter):
	if self.is_null():
		return
	if new_leg_diameter != Leg_Diameter:
		Leg_Diameter = new_leg_diameter
		self.redraw()


func get_leg_diameter():
	return Leg_Diameter


func set_top_material(new_top_material):
	if self.is_null():
		return
	if new_top_material != Top_Material:
		Top_Material = new_top_material
		$Top.set_surface_material(Top_Material)


func get_top_material():
	return Top_Material


func set_leg_material(new_leg_material):
	if self.is_null():
		return
	if new_leg_material != Leg_Material:
		Leg_Material = new_leg_material
		$Leg1.set_surface_material(Leg_Material)
		$Leg2.set_surface_material(Leg_Material)
		$Leg3.set_surface_material(Leg_Material)
		$Leg4.set_surface_material(Leg_Material)


func get_leg_material():
	return Leg_Material



