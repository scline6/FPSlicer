#ifndef SLICER_H_INCLUDED
#define SLICER_H_INCLUDED




#include <array>
#include <vector>
#include <unordered_set>
#include <algorithm>
#include <functional>
#include <numeric_limits>

#include "Vec3.h"




const double          EPSILON          = 1e-12;
const double          ONE_MINUS_EPS    = 1.0 - EPSILON;
const double          MAX_DOUBLE       = std::numeric_limits<double>::max();
const double          MIN_DOUBLE       = std::numeric_limits<double>::min();


const std::size_t     DIM_X            = 0;
const std::size_t     DIM_Y            = 1;
const std::size_t     DIM_Z            = 2;


typedef    std::array<std::size_t, 2>    Edge;
typedef    std::array<std::size_t, 3>    Triangle;




class Slicer {

public:

    void setMesh(const std::function<Vec3(const Vec3&)>& transform, 
                 const std::vector<Vec3>&                vertices0,
                 const std::vector<Triangle>&            triangles0);
    
    void setVoxelization(const double& xWidth, 
                         const std::size_t& nx, 
                         const double& yWidth, 
                         const std::size_t& ny, 
                         const double& layerHeight);
               
    void voxelize();
    
    double getVoxelValue(const std::size_t& i, const std::size_t& j, const std::size_t& k);
    


protected:

    enum SweepItemType {
		UNDEFINED      = 0,
		SLICING_PLANE  = 1,
		TRIANGLE_START = 2, 
		TRIANGLE_END   = 3,
		ENTER_SOLID    = 4,
		EXIT_SOLID     = 5,
		VOXVAL_ONE     = 6,
		VOXVAL_PARTIAL = 7
	}


    static SweepItemType opposite(const SweepItemType& s) {
        return (s == SweepItemType::ENTER_SOLID ? SweepItemType::EXIT_SOLID : 
                                                 (s == SweepItemType::EXIT_SOLID ? SweepItemType::ENTER_SOLID : 
                                                                                   SweepItemType::UNDEFINED));
	}
	

    struct SweepItem {
		double      ordinate;
		std::size_t index;
		SweepItemType type;
		SweepItem(const double& s, const std::size_t& i, const SweepItemType& t=UNDEFINED) 
		    : ordinate(s), index(i), type(t) {}
	    bool operator<(const Slicer::SweepItem& other) const {
	        return this->ordinate < other.ordinate;
		}
	    bool lessThan2(const Slicer::SweepItem& other) const {
	    	if (abs(this->ordinate - other.ordinate) < EPSILON) {    // Allow a tolerance when deciding if a triangle spans a slice
	    		if      (this->type == TRIANGLE_START && other.type == SLICING_PLANE) {
	    			return true;
	    	    }
	    	    else if (this->type == SLICING_PLANE  && other.type == TRIANGLE_START) {
	    			return false;
	    		}
	    		else if (this->type == TRIANGLE_END   && other.type == SLICING_PLANE) {
	    			return false;
	    	    }
	    	    else if (this->type == SLICING_PLANE  && other.type == TRIANGLE_END) {
	    			return true;
	    		}
	    	}
	        return this->ordinate < other.ordinate;
	    };
	};
	
	
	struct RunLengthEncodedEntry {    // Designed to be as small as possible to keep memory usage under 100MB
        std::int16_t entry0;
		std::int16_t entry1;
		void setValue(const double& value) {
			const double upper = double(std::numeric_limits<std::int16_t>::max()) + 1.0;
			this->entry0 = std::int16_t(value * upper);
		}
		double getValue() const {
			const double upper = double(std::numeric_limits<std::int16_t>::max()) + 1.0;
			return (double(this->entry) / upper);
		}
		void setIndex(const std::size_t& i) {
			// add out-of-bounds error checks
		    this->entry1 = i;
	    }
	    std::size_t getIndex() const {
			return std::size_t(this->entry1);
		}
		void setStartIndex(const std::size_t& i) {
			// add out-of-bounds error checks
			this->entry0 = i;
		}
	    std::size_t getStartIndex() const {
			return std::size_t(this->entry0);
		}
		void setEndIndex(const std::size_t& i) {
			// add out-of-bounds error checks
			this->entry1 = i;
		}
	    std::size_t getEndIndex() const {
			return std::size_t(this->entry1);
		}
		void setType(const SweepItemType& type) {
			this->entry0 = (type == VOXVAL_ONE ? abs(this->entry0) : -abs(this->entry0));
		}
		SweepItemType getType() const {
			return (this->entry0 >= 0 ? VOXVAL_ONE : VOXVAL_PARTIAL);
		}
		static RunLengthEncodedEntry One(const std::size_t& i0, const std::size_t& i1) {
			RunLengthEncodedEntry entry;
			entry.setStartIndex(i0);
			entry.setEndIndex(i1);
			entry.setType(VOXVAL_ONE);
			return entry;
		} 
		static RunLengthEncodedEntry Partial(const std::size_t& i, const double& value) {
			RunLengthEncodedEntry entry;
			entry.setIndex(i);
			entry.setValue(value);
			entry.setType(VOXVAL_PARTIAL);
			return entry;
		}
	};
		
		
	typedef    std::vector<std::vector<std::vector<RunLengthEncodedEntry> > >      SparseVoxelGrid;



protected:
	
    std::vector<Vec3>                  vertices;
    std::vector<Triangle>              triangles;
    Vec3                               rMin;
    Vec3                               rMax;
    std::array<std::vector<double>, 3> levels;
	SparseVoxelGrid                    sparseVoxelGrid;
	
	
	
protected:

    std::array<std::vector<std::vector<std::size_t> > >, 2> spanningTrianglesForPlanes();
    
    std::vector<SweepItem> intersectScanLine(const std::vector<std::size_t>& triangleVector, 
                                             const double& x, 
                                             const double& y);
                                                     
    std::vector<double> voxelizeScanLine(const std::vector<SweepItem>& intersections);
	
    std::vector<SweepItem> runLengthEncode(const std::vector<double>& denseVoxels) {
	
};



#endif //SLICER_H_INCLUDED



