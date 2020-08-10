#include "STL_Mesh3.h"




using namespace godot;




void STL_Mesh3::_register_methods() {
    godot::register_method("_init",         &STL_Mesh3::_init);
    godot::register_method("_process",      &STL_Mesh3::_process);
    godot::register_method("read_STL_file", &STL_Mesh3::read_STL_file);
    godot::register_method("draw_mesh",     &STL_Mesh3::draw_mesh);
    godot::register_method("drop_to_plate", &STL_Mesh3::drop_to_plate);
}




// Empty methods, ready for future use
STL_Mesh3::STL_Mesh3() {}
STL_Mesh3::~STL_Mesh3() {}
void STL_Mesh3::_ready() {}
void STL_Mesh3::_process(float delta) {}




void STL_Mesh3::_init() {
	this->meshInstance = MeshInstance::_new();
	this->add_child(this->meshInstance);
	
	SpatialMaterial* sm = SpatialMaterial::_new();
	this->meshInstance->set_material_override(sm);
	sm->set_flag(SpatialMaterial::Flags::FLAG_ALBEDO_FROM_VERTEX_COLOR, true);
	
	Basis basis = Basis(Vector3(0.0,0.1,0.0), Vector3(0.0,0.0,0.1), Vector3(0.1,0.0,0.0));
	Transform transform(basis, Vector3(0.0, 0.0, 0.0));
	this->set_transform(transform);    //View-transform;
}




void STL_Mesh3::read_STL_file(String filepath) {
	auto file = File::_new();
	bool exists = file->file_exists(filepath);
	if (!exists) return;
	Error result = file->open(filepath, File::ModeFlags::READ);
	if (result != Error::OK) return;
	while (!file->eof_reached()) {
		String line = file->get_line();
		PoolStringArray tokens = line.split(String(" "), false);
		if (line.find(String("vertex")) >= 0) {
			double x = double(tokens[1].to_float());
			double y = double(tokens[2].to_float());
			double z = double(tokens[3].to_float());
			this->vertices.push_back({x, y, z});
		}
		else if (line.find(String("endloop")) >= 0) {
			const std::size_t& n = this->vertices.size();
			this->triangles.push_back({n-3, n-2, n-1});
		}
	}
	file->close();
}




void STL_Mesh3::draw_mesh(Color color) {
	auto st = SurfaceTool::_new();
	st->begin(Mesh::PRIMITIVE_TRIANGLES);
	st->add_color(color);
	for (const auto& v : this->vertices) {
		st->add_vertex(Vector3(v[0], v[1], v[2]));
	}
	for (const auto& t : this->triangles) {
		st->add_index(t[0]);
		st->add_index(t[1]);
		st->add_index(t[2]);
	}
	st->generate_normals();
	this->meshInstance->set_mesh(st->commit());
}




void STL_Mesh3::drop_to_plate() {
	double zMin = 999999999.0;
	for (const auto& v : this->vertices) {
		Vector3 r = this->meshInstance->get_transform().xform(Vector3(v[0], v[1], v[2]));
		zMin = r.z < zMin ? r.z : zMin;
	}
	this->meshInstance->translate(Vector3(0.0, 0.0, -zMin));
}




const std::vector<Vec3>& STL_Mesh3::get_vertices() const {
	return this->vertices;
}




const std::vector<Triangle>& STL_Mesh3::get_triangles() const {
	return this->triangles;
}




const MeshInstance* STL_Mesh3::getMeshInstance() const {
	return this->meshInstance;
}



