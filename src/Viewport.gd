extends Viewport


func _ready():
	pass # Replace with function body.


func _on_FileDialog_file_selected(path):
	var scene = preload("res://STL_Mesh2.tscn")
	var newMesh = scene.instance()
	newMesh.read_STL_ascii(path)
	var n = self.get_child_count()
	var color = Color(1.0, 1.0, 1.0)
	if n % 6 == 0:
		color = Color(0.2, 0.8, 0.5)
	elif n % 6 == 1:
		color = Color(0.5, 0.2, 0.8)
	elif n % 6 == 2:
		color = Color(0.8, 0.5, 0.2)
	elif n %6 == 3:
		color = Color(0.5, 0.8, 0.2)
	elif n % 6 == 4:
		color = Color(0.8, 0.2, 0.5)
	elif n % 6 == 5:
		color = Color(0.2, 0.5, 0.8)
	newMesh.draw_mesh(true, color)
	self.get_node("Printer3D").add_child(newMesh)

