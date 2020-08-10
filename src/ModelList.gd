extends ItemList


var Printer3D = null
var model_directory = {}
var total_models_opened = 0



func _ready():
	self.Printer3D = self.get_tree().get_root().find_node("Printer3D", true, false)


func choose_mesh_name(path):
	var filename = path.get_file()
	for j in range(0, 1000):
		var mesh_name = filename
		if j > 0:
			mesh_name += "." + str(j)
		var conflict = false
		for i in range(0, self.get_item_count()):
			if mesh_name == self.get_item_text(i):
				conflict = true
				break
		if conflict == false:
			return mesh_name


func unselect_all_unless_1():
	if self.get_item_count() != 1:
		self.unselect_all()
		self.emit_signal("nothing_selected")


func select_item1_if_only1():
	if self.get_item_count() == 1:
		self.select(0, true)
		self.emit_signal("multi_selected", 0, true)


func select_1_otherwise_unselect_all():
	self.unselect_all_unless_1()
	self.select_item1_if_only1()


func add_mesh(mesh_name, mesh):
	if self.Printer3D == null:
		return
	self.model_directory[mesh_name] = mesh
	self.add_item(mesh_name)
	self.Printer3D.add_child(mesh)


func remove_mesh(index):
	if self.Printer3D == null:
		return
	var mesh_name = self.get_item_text(index)
	var mesh = self.model_directory[mesh_name]
	self.remove_item(index)
	self.Printer3D.remove_child(mesh)
	self.model_directory.erase(index)


func open_STL_file(path):
	if self.Printer3D == null:
		return
	var n = self.total_models_opened
	self.total_models_opened += 1
	var phi = 1.0 - 0.61803398875
	var r = 0.25 + 0.5 * fmod(float(n*11+18) * phi, 1.0)
	var g = 0.25 + 0.5 * fmod(float(n*13+17) * phi, 1.0)
	var b = 0.25 + 0.5 * fmod(float(n*7 +19) * phi, 1.0)
	var color = Color(r, g, b)
	#print(color)
	var mesh_name = self.choose_mesh_name(path)
	var use_cpp = true
	if use_cpp:
		var newMesh = preload("res://GDNative/STL_Mesh3.gdns").new()
		newMesh.read_STL_file(path)
		self.add_mesh(mesh_name, newMesh)
		newMesh.draw_mesh(color)
	else:
		var scene = preload("res://STL_Mesh2.tscn")
		var newMesh = scene.instance()
		newMesh.read_STL_ascii(path)
		self.add_mesh(mesh_name, newMesh)
		newMesh.draw_mesh(color)


func _on_ModelOpenFileDialog2_files_selected(paths):
	for path in paths:
		self.open_STL_file(path)
	self.select_1_otherwise_unselect_all()


func _on_CloseButton_pressed():
	var selected_items = self.get_selected_items()
	selected_items.invert()
	for i in selected_items:
		self.remove_mesh(i)
	self.select_1_otherwise_unselect_all()


func _on_ShowButton_pressed():
	for i in self.get_selected_items():
		var mesh_name = self.get_item_text(i)
		var mesh = self.model_directory[mesh_name]
		if mesh == null:
			continue
		mesh.set_visible(true)


func _on_HideButton_pressed():
	for i in self.get_selected_items():
		var mesh_name = self.get_item_text(i)
		var mesh = self.model_directory[mesh_name]
		if mesh == null:
			continue
		mesh.set_visible(false)


func _on_DropToPlateButton_pressed():
	for i in self.get_selected_items():
		var mesh_name = self.get_item_text(i)
		var mesh = self.model_directory[mesh_name]
		if mesh == null:
			continue
		mesh.drop_to_plate()





func _on_ScaleButton_pressed():
	for i in self.get_selected_items():
		var mesh_name = self.get_item_text(i)
		var mesh = self.model_directory[mesh_name]
		if mesh == null:
			continue
		mesh.global_scale(Vector3(1.1, 1.1, 1.1))  #Test






