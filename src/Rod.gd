tool
extends StaticBody


export           var Cylinder_Height  = 2.0                    setget set_cylinder_height,  get_cylinder_height
export           var Bottom_Radius    = 1.0                    setget set_bottom_radius,    get_bottom_radius
export           var Top_Radius       = 1.0                    setget set_top_radius,       get_top_radius
export(Material) var Surface_Material = null                   setget set_surface_material, get_surface_material



func redraw():
	$MeshInstance.mesh.set_height(Cylinder_Height)
	$MeshInstance.mesh.set_bottom_radius(Bottom_Radius)
	$MeshInstance.mesh.set_top_radius(Top_Radius)
	var r = 0.5 * (Bottom_Radius + Top_Radius)
	$CollisionShape.shape.set_height(Cylinder_Height)
	$CollisionShape.shape.set_radius(r)
	$CollisionShape.shape.set_radius(r)


func set_cylinder_height(new_cylinder_height):
	if $MeshInstance == null or $CollisionShape == null:
		return
	if new_cylinder_height != Cylinder_Height:
		Cylinder_Height = new_cylinder_height
		self.redraw()


func get_cylinder_height():
	return Cylinder_Height


func set_bottom_radius(new_bottom_radius):
	if $MeshInstance == null or $CollisionShape == null:
		return
	if new_bottom_radius != Bottom_Radius:
		Bottom_Radius = new_bottom_radius
		self.redraw()
	

func get_bottom_radius():
	return Bottom_Radius


func set_top_radius(new_top_radius):
	if $MeshInstance == null or $CollisionShape == null:
		return
	if new_top_radius != Top_Radius:
		Top_Radius = new_top_radius
		self.redraw()


func get_top_radius():
	return Top_Radius


func set_surface_material(new_surface_material):
	if $MeshInstance == null:
		return
	if new_surface_material != $MeshInstance.material_override:
		Surface_Material = new_surface_material
		$MeshInstance.material_override = Surface_Material


func get_surface_material():
	return Surface_Material


func _ready():
	pass


