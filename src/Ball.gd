tool
extends StaticBody


export           var Ball_Radius      = 1.0                    setget set_ball_radius,      get_ball_radius
export           var Ball_Height      = 2.0                    setget set_ball_height,      get_ball_height
export(Material) var Surface_Material = null                   setget set_surface_material, get_surface_material




func set_ball_radius(new_ball_radius):
	if $MeshInstance == null or $CollisionShape == null:
		return
	if new_ball_radius != Ball_Radius:
		Ball_Radius = new_ball_radius
		$MeshInstance.mesh.set_radius(new_ball_radius)
		var r = max(new_ball_radius, 0.5 * Ball_Height)
		$CollisionShape.shape.set_radius(r)
	

func get_ball_radius():
	return Ball_Radius


func set_ball_height(new_ball_height):
	if $MeshInstance == null or $CollisionShape == null:
		return
	if new_ball_height != Ball_Height:
		Ball_Height = new_ball_height
		$MeshInstance.mesh.set_height(Ball_Height)


func get_ball_height():
	return Ball_Height


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


