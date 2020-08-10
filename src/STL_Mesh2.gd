extends Spatial


var vertices = []
var triangles = []

var MeshInstance = null
var zPlate = 0.0


func _ready():
	self.MeshInstance = $MeshInstance
	self.transform = Transform(Vector3(0.0,0.0,0.1), Vector3(0.1,0.0,0.0), Vector3(0.0,0.1,0.0), Vector3(0.0,0.0,0.0))    #View-transform


func read_STL_ascii(filepath):
	var file = File.new()
	var result = file.open(filepath, File.READ)
	if result != 0:
		return
	while not file.eof_reached():
		var line = file.get_line()
		var tokens = line.split(" ",false)
		if "solid" in line:
			#var name = tokens[1]
			pass
		elif "facet normal" in line:
			#var normal = Vector3(float(tokens[2]), float(tokens[3]), float(tokens[4]))
			pass
		elif "outer loop" in line:
			pass
		elif "vertex" in line:
			var r = Vector3(float(tokens[1]), float(tokens[2]), float(tokens[3]))
			self.vertices.push_back(r)
		elif "endloop" in line:
			var n = self.vertices.size()
			self.triangles.push_back([n-3, n-2, n-1])
		elif "endfacet" in line:
			pass
		elif "endsolid" in line:
			return


func draw_mesh(color=Color(1.0,1.0,1.0,1.0)):
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.add_color(color)
	for vertex in self.vertices:
		st.add_vertex(vertex)
	for triangle in self.triangles:
		st.add_index(triangle[0])
		st.add_index(triangle[1])
		st.add_index(triangle[2])
	st.generate_normals()
	self.MeshInstance.mesh = null
	self.MeshInstance.mesh = st.commit()


func drop_to_plate():
	var zMin = 999999999.0
	for vertex in self.vertices:
		var r = self.MeshInstance.transform.xform(vertex)    #Model-transform
		zMin = min(zMin, r.z)
	self.MeshInstance.translate(Vector3(0.0, 0.0, zPlate-zMin))    #Model-transform


