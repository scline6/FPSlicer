tool
extends KinematicBody


export(Vector3)  var Tablet_Size     = Vector3(11.0, 16.0, 0.5) setget set_tablet_size,     get_tablet_size
export(Material) var Case_Material   = null                     setget set_case_material,   get_case_material
export(Material) var Screen_Material = null                     setget set_screen_material, get_screen_material
export(String)   var Viewport_Name   = "Viewport"               setget set_viewport_name,   get_viewport_name



func is_null():
	if self.get_child_count() == 0:
		return true
	else:
		for i in range(0, self.get_child_count()):
			if self.get_child(i) == null:
				return true
		return false


func set_tablet_size(new_tablet_size):
	if self.is_null():
		return
	if new_tablet_size != Tablet_Size:
		Tablet_Size = new_tablet_size
		$Box1.set_box_size(Vector3(Tablet_Size.x, Tablet_Size.z, Tablet_Size.z))
		$Box1.set_translation(Vector3(0.0, -0.5 * Tablet_Size.y + 0.5 * Tablet_Size.z, -0.5 * Tablet_Size.z))
		$Box2.set_box_size(Vector3(Tablet_Size.x, Tablet_Size.z, Tablet_Size.z))
		$Box2.set_translation(Vector3(0.0, +0.5 * Tablet_Size.y - 0.5 * Tablet_Size.z, -0.5 * Tablet_Size.z))
		$Box3.set_box_size(Vector3(Tablet_Size.z, Tablet_Size.y - 2.0 * Tablet_Size.z, Tablet_Size.z))
		$Box3.set_translation(Vector3(-0.5 * Tablet_Size.x + 0.5 * Tablet_Size.z, 0.0, -0.5 * Tablet_Size.z))
		$Box4.set_box_size(Vector3(Tablet_Size.z, Tablet_Size.y - 2.0 * Tablet_Size.z, Tablet_Size.z))
		$Box4.set_translation(Vector3(+0.5 * Tablet_Size.x - 0.5 * Tablet_Size.z, 0.0, -0.5 * Tablet_Size.z))
		$ViewScreen.set_screen_size(Vector2(Tablet_Size.x - 2.0 * Tablet_Size.z, Tablet_Size.y - 2.0 * Tablet_Size.z))
		$ViewScreen.set_translation(Vector3(0.0, 0.0, 0.0))


func get_tablet_size():
	return Tablet_Size


func set_case_material(new_case_material):
	if self.is_null():
		return
	if new_case_material != Case_Material:
		Case_Material = new_case_material
		$Box1.set_surface_material(Case_Material)
		$Box2.set_surface_material(Case_Material)
		$Box3.set_surface_material(Case_Material)
		$Box4.set_surface_material(Case_Material)


func get_case_material():
	return Case_Material


func set_screen_material(new_screen_material):
	if self.is_null():
		return
	if new_screen_material != Screen_Material:
		Screen_Material = new_screen_material
		$ViewScreen.set_screen_material(Screen_Material)


func get_screen_material():
	return Screen_Material


func set_viewport_name(new_viewport_name):
	if new_viewport_name != Viewport_Name:
		Viewport_Name = new_viewport_name
		$ViewScreen.set_viewport_name(Viewport_Name)


func get_viewport_name():
	return Viewport_Name


