tool
extends Spatial


export(Vector3)  var Box_Size        = Vector3(20.0, 10.0, 20.0) setget set_box_size,       get_box_size
export(Material) var Plate_Material  = null                      setget set_plate_material, get_plate_material
export(Material) var Base_Material   = null                      setget set_base_material,  get_base_material
export(Material) var Drive_Material  = null




func is_null():
	if self.get_child_count() == 0:
		return true
	else:
		for i in range(0, self.get_child_count()):
			if self.get_child(i) == null:
				return true
		return false


func redraw():
	var dy_base  = 0.80 * Box_Size.y
	var dy_drive = 0.15 * Box_Size.y
	var dy_plate = 0.05 * Box_Size.y
	var y = -Box_Size.y + 0.5 * dy_base
	$Base.set_translation(Vector3(0.0, y, 0.0))
	$Base.set_box_size(Vector3(Box_Size.x, dy_base, Box_Size.z))
	y = -dy_plate - 0.5 * dy_drive
	var dx = Box_Size.x - 2.0 * dy_drive
	var dz = Box_Size.z - 2.0 * dy_drive
	$Drive.set_translation(Vector3(0.0, y, 0.0))
	$Drive.set_box_size(Vector3(dx, dy_drive, dz))
	y = -0.5 * dy_plate
	$Plate.set_translation(Vector3(0.0, y, 0.0))
	$Plate.set_box_size(Vector3(Box_Size.x, dy_plate, Box_Size.z))
    

func set_box_size(new_box_size):
	if self.is_null():
		return
	if new_box_size != Box_Size:
		Box_Size = new_box_size
		self.redraw()


func get_box_size():
	return Box_Size


func set_plate_material(new_plate_material):
	if self.is_null():
		return
	if new_plate_material != Plate_Material:
		Plate_Material = new_plate_material
		$Plate.set_surface_material(Plate_Material)


func get_plate_material():
	return Plate_Material


func set_drive_material(new_drive_material):
	if self.is_null():
		return
	if new_drive_material != Drive_Material:
		Drive_Material = new_drive_material
		$Drive.set_surface_material(Drive_Material)


func get_drive_material():
	return Drive_Material


func set_base_material(new_base_material):
	if self.is_null():
		return
	if new_base_material != Base_Material:
		Base_Material = new_base_material
		$Base.set_surface_material(Base_Material)


func get_base_material():
	return Base_Material



