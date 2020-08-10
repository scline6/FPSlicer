#ifndef STL_MESH3_H_INCLUDED
#define STL_MESH3_H_INCLUDED


#include <Godot.hpp>
#include <Spatial.hpp>
#include <MeshInstance.hpp>
#include <ArrayMesh.hpp>
#include <SurfaceTool.hpp>
#include <SpatialMaterial.hpp>
#include <File.hpp>
#include <array>
#include <vector>
#include "Vec3.h"




typedef    std::array<std::size_t, 2>    Edge;
typedef    std::array<std::size_t, 3>    Triangle;




namespace godot {


class STL_Mesh3 : public Spatial {
    GODOT_CLASS(STL_Mesh3, Spatial)

public:

    static void _register_methods();
    
    STL_Mesh3();
    
    ~STL_Mesh3();

    void _init();
    
    void _ready();

    void _process(float delta);
    
    void read_STL_file(String filepath);
    
    void draw_mesh(Color color);
    
    void drop_to_plate();
    
    const std::vector<Vec3>& get_vertices() const;
    
    const std::vector<Triangle>& get_triangles() const;

    const MeshInstance* getMeshInstance() const;


protected:

	std::vector<Vec3> vertices;
	std::vector<Triangle> triangles;
	MeshInstance* meshInstance;
    
};


}


#endif
