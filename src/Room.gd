tool
extends Spatial


export(Vector3)  var Room_Size        = Vector3(200.0, 200.0, 200.0) setget set_room_size,        get_room_size
export           var Wall_Thickness   = 5.0                          setget set_wall_thickness,   get_wall_thickness
export(Material) var Floor_Material   = null                         setget set_floor_material,   get_floor_material
export(Material) var Ceiling_Material = null                         setget set_ceiling_material, get_ceiling_material
export(Material) var Wall_Material    = null                         setget set_wall_material,    get_wall_material



func is_null():
	if self.get_child_count() == 0:
		return true
	else:
		for i in range(0, self.get_child_count()):
			if self.get_child(i) == null:
				return true
		return false


func redraw():
	var x = 0.0
	var y = -0.5 * Wall_Thickness
	var z = 0.0
	var dx = Room_Size.x + 2.0 * Wall_Thickness
	var dy = Wall_Thickness
	var dz = Room_Size.z + 2.0 * Wall_Thickness
	
	print("ABC: ", $Floor, self.is_null())
	
	$Floor.set_translation(Vector3(x, y, z))
	$Floor.set_box_size(Vector3(dx, dy, dz))
	y = Room_Size.y + 0.5 * Wall_Thickness
	$Ceiling.set_translation(Vector3(x, y, z))
	$Ceiling.set_box_size(Vector3(dx, dy, dz))
	x = -0.5 * Room_Size.x - 0.5 * Wall_Thickness
	y =  0.5 * Room_Size.y
	z = 0.0
	dx = Wall_Thickness
	dy = Room_Size.y
	dz = Room_Size.z
	$Wall1.set_translation(Vector3(x, y, z))
	$Wall1.set_box_size(Vector3(dx, dy, dz))
	x = 0.5 * Room_Size.x + 0.5 * Wall_Thickness
	$Wall2.set_translation(Vector3(x, y, z))
	$Wall2.set_box_size(Vector3(dx, dy, dz))
	x = 0.0
	y =  0.5 * Room_Size.y
	z = -0.5 * Room_Size.z - 0.5 * Wall_Thickness
	dx = Room_Size.x + Wall_Thickness
	dy = Room_Size.y
	dz = Wall_Thickness
	$Wall3.set_translation(Vector3(x, y, z))
	$Wall3.set_box_size(Vector3(dx, dy, dz))
	z = 0.5 * Room_Size.z + 0.5 * Wall_Thickness
	$Wall4.set_translation(Vector3(x, y, z))
	$Wall4.set_box_size(Vector3(dx, dy, dz))


func set_room_size(new_room_size):
	if self.is_null():
		return
	if new_room_size != Room_Size:
		Room_Size = new_room_size
		self.redraw()


func get_room_size():
	return Room_Size


func set_wall_thickness(new_wall_thickness):
	if self.is_null():
		return
	if new_wall_thickness != Wall_Thickness:
		Wall_Thickness = new_wall_thickness
		self.redraw()


func get_wall_thickness():
	return Wall_Thickness


func set_floor_material(new_floor_material):
	if self.is_null():
		return
	if new_floor_material != Floor_Material:
		Floor_Material = new_floor_material
		$Floor.set_surface_material(Floor_Material)


func get_floor_material():
	return Floor_Material


func set_ceiling_material(new_ceiling_material):
	if self.is_null():
		return
	if new_ceiling_material != Ceiling_Material:
		Ceiling_Material = new_ceiling_material
		$Ceiling.set_surface_material(Ceiling_Material)


func get_ceiling_material():
	return Ceiling_Material


func set_wall_material(new_wall_material):
	if self.is_null():
		return
	if new_wall_material != Wall_Material:
		Wall_Material = new_wall_material
		$Wall1.set_surface_material(Wall_Material)
		$Wall2.set_surface_material(Wall_Material)
		$Wall3.set_surface_material(Wall_Material)
		$Wall4.set_surface_material(Wall_Material)


func get_wall_material():
	return Wall_Material



