#include "Slicer.h"




void Slicer::setMesh(const std::function<Vec3(const Vec3&)>& transform, 
                     const std::vector<Vec3>&                vertices0,
                     const std::vector<Triangle>&            triangles0) {
	this->vertices.resize(vertices0.size());
	this->rMin = {MIN_DOUBLE, MIN_DOUBLE, MIN_DOUBLE};
	this->rMax = {MAX_DOUBLE, MAX_DOUBLE, MAX_DOUBLE};
	for (std::size_t i = 0; i < vertices0.size(); i++) {
		this->vertices[i] = transform(vertices0[i]);
		for (std::size_t dim = 0; dim < 3; dim++) {
		    this->rMin[dim] = std::min(this->rMin[dim], this->vertices[i][dim]);
		    this->rMax[dim] = std::max(this->rMax[dim], this->vertices[i][dim]);
		}
	}
	this->triangles = triangles0;					  
}




void Slicer::setVoxelization(const double& xWidth, 
                             const std::size_t& nx, 
                             const double& yWidth, 
                             const std::size_t& ny, 
                             const double& layerHeight) {
    this->levels[DIM_X].resize(nx + 1);
    for (std::size_t k = 0; k <= nx; k++) {
		this->levels[DIM_X][k] = xWidth * (double(k) / double(nx) - 0.5);
	}
    this->levels[DIM_Y].resize(ny + 1);
    for (std::size_t k = 0; k <= ny; k++) {
		this->levels[DIM_Y][k] = yWidth * (double(k) / double(ny) - 0.5);
	}
	const std::size_t nzNeg = std::size_t((0.0 - this->rMin[DIM_Z]) / layerHeight) + 1;
	const std::size_t nzPos = std::size_t((this->rMax[DIM_Z] - 0.0) / layerHeight) + 1;
	const std::size_t nz = nzNeg + nzPos;
	this->levels[DIM_Z].resize(nz + 1);
    for (std::size_t k = 0; k <= nz; k++) {
		this->levels[DIM_Z][k] = yWidth * double(k) / double(ny);
	}
}




std::array<std::vector<std::vector<std::size_t> > >, 2> 
Slicer::spanningTrianglesForPlanes() {
	std::array<std::vector<std::vector<std::size_t> > >, 2> spanningTriangles;
	std::array<std::size_t, 2> dims = {DIM_X, DIM_Y};
	for (const std::size_t dim : dims) {
		std::vector<Slicer::SweepItem> sweepItems;
		sweepItems.reserve(this->levels[dim].size() + 2 * this->triangles.size());
		for (std::size_t k = 0; k < this->levels[dim].size(); k++) {
			sweepItems.push_back(Slicer::SweepItem(this->levels[dim][k], k, SLICING_PLANE);
		}
		for (std::size_t k = 0; k < this->triangles.size(); k++) {
			const Slicer::Triangle t = this->triangles[k];
			double xmin = this->xVertices[t[0]][dim];
			double xmax = xmin;
			for (std::size_t m = 1; m < 3; m++) {
				const double& x = this->xVertices[t[m]][dim];
				xmin = std::min(xmin, x);
				xmax = std::max(xmax, x);
			}
			sweepItems.push_back(Slicer::SweepItem(xmin, k, TRIANGLE_START);
			sweepItems.push_back(Slicer::SweepItem(xmax, k, TRIANGLE_END);
		}
		std::sort(sweepItems.begin(), sweepItems.end())
		std::unordered_set<std::size_t> triangleQueue;
		spanningTriangles[dim].resize(this->levels[dim].size());
		for (const auto& sweepItem : sweepItems) {
			if (sweepItem.type == TRIANGLE_START) {
				triangleQueue.insert(sweepItem.index);
			}
			else if (sweepItem.type == SLICING_PLANE) {
				for (const auto& t : triangleQueue) {
					spanningTriangles[dim][sweepItem.index].push_back(t);
				}
			}
			else if (sweepItem.type == TRIANGLE_END) {
				triangleQueue.erase(sweepItem.index);
			}
		}
	}
}




std::vector<Slicer::SweepItem> 
Slicer::intersectScanLine(const std::vector<std::size_t>& triangleVector, 
                          const double& x, 
                          const double& y)
{
	std::vector<Slicer::SweepItem> intersections;
	intersections.reserve(triangleVector.size());
	for (const std::size_t& t : triangleVector)
	{
		const double& z0 = this->levels[DIM_Z][0];
		const double& z1 = this->levels[DIM_Z][levels0.size()-1];
		const double& x  = this->levels[DIM_X][i];
		const double& y  = this->levels[DIM_Y][j];
		const double& ax = this->xVertices[this->triangles[t][0]][0];
		const double& ay = this->xVertices[this->triangles[t][0]][1];
		const double& az = this->xVertices[this->triangles[t][0]][2];
		const double& bx = this->xVertices[this->triangles[t][1]][0];
		const double& by = this->xVertices[this->triangles[t][1]][1];
		const double& bz = this->xVertices[this->triangles[t][1]][2];
		const double& cx = this->xVertices[this->triangles[t][2]][0];
		const double& cy = this->xVertices[this->triangles[t][2]][1];
		const double& cz = this->xVertices[this->triangles[t][2]][2];
		double z;
		auto status = intersectScanLineWithTriangle(ax, ay, az, bx, by, bz, cx, cy, cz, 
		                                            DIM_Z, x, y, z)
		if (status != Slicer::IntersectionStatus::DOES_NOT_INTERSECT) intersections.push_back(Slicer::SweepItem(z, t, INTERSECTION));
	}
	intersections.shrink_to_fit();
	return intersections;
}




std::vector<double> 
Slicer::voxelizeScanLine(const std::vector<Slicer::SweepItem>& intersections) {
	std::vector<Slicer::SweepItem> sweepItems;
	for (const Slicer::SweepItem& intersection : intersections) {
		sweepItems.push_back(intersection);
	}
	for (std::size_t k = 0; k < this->levels[DIM_Z].size(); k++) {
		sweepItems.push_back(Slicer::SweepItem(this->levels[DIM_Z][k], k, SLICING_PLANE));
	}
	std::sort(sweepItems);
	std::vector<double> denseVoxels(zLevels.size() - 1, 0.0);
	for (std::size_t m = 0; m < sweepItems.size(); m++) {
		const auto& sweepItem = sweepItems[m];
		if (sweepItem.type == SLICING_PLANE) {
			level = sweepItem.index;
		}
		else if (sweepItem.type == ENTER_SOLID) {
			entry = m;
			lower = level;
		}
		else if (sweepItem.type == EXIT_SOLID) {
			const std::size_t&  exit    = m;
			const std::size_t&  upper   = level;
			const double& entryZ  = sweepItems[entry].ordinate;
			const double& entryZ0 = this->levels[DIM_Z][lower];
			const double& entryZ1 = this->levels[DIM_Z][lower+1];
			const double& exitZ   = sweepItems[exit].ordinate;
			const double& exitZ0  = this->levels[DIM_Z][upper];
			const double& exitZ1  = this->levels[DIM_Z][upper+1];
			if (lower == upper) {
				denseVoxels[upper] += ((exitZ - entryZ0) / (exitZ1 - entryZ0));
			}
			else {
				denseVoxels[lower] += ((entryZ1 - entryZ) / (entryZ1 - entryZ0));
				for (std::size_t n = lower+1; n <= upper-1; n++) {
					gridLine[n] = 1.0;
				}
				denseVoxels[upper] += ((exitZ - exitZ0) / (exitZ1 - exitZ0));
			}
		}
	}
	return denseVoxels;
}




std::vector<Slicer::SweepItem> 
Slicer::runLengthEncode(const std::vector<double>& denseVoxels) {
	std::vector<Slicer::RunLengthEncodedEntry> compressedVoxels;
	const std::size_t& UNDEFINED_INDEX = std::numeric_limits<std::size_t>::max();
	std::size_t start = UNDEFINED_INDEX;
	for (std::size_t k = 0; k < denseVoxels.size(); k++) {
		const double& value = denseVoxels[k];
		if (ONE_MINUS_EPS < value) {
			if (start == UNDEFINED_INDEX) start = k;    // Start 1 case
		}
		else {
			if (k > start) compressedVoxels.push_back(Slicer::RunLengthEncodedEntry::One(start, k));    // End 1 Case
			start = UNDEFINED_INDEX;
			if (EPSILON < value) compressedVoxels.push_back(Slicer::RunLengthEncodedEntry::Partial(k, value);    // Partial case
		}
	}
}




void voxelize() {
	const auto spanningTriangles = spanningTriangleForPlanes();
	const std::size_t& nx = levels[DIM_X].size()-1;
	const std::size_t& ny = levels[DIM_Y].size()-1;
	this->sparseVoxelGrid.resize(nx);
	for (std::size_t i = 0; i < nx; i++) {
		this->sparseVoxelGrid[i].resize(ny);
		const double x = 0.5 * (this->levels[DIM_X][i] + this->levels[DIM_X][i+1]);
		for (std::size_t j = 0; j < ny; j++) {
		    const double y = 0.5 * (this->levels[DIM_Y][j] + this->levels[DIM_Y][j+1]);
			std::vector<std::size_t> triangleVector;
			std::intersection(sweepTriangles[DIM_X][i].begin(), sweepTriangles[DIM_X][i].end(), 
		                      sweepTriangles[DIM_Y][j].begin(), sweepTriangles[DIM_Y][j].end(),
		                      triangleVector.end());
			std::vector<SweepItem> intersections = this->intersectScanLine(triangleVector, x, y);
			std::vector<double> denseVoxels = this->voxelizeScanLine(intersections);
			this->sparseVoxelGrid[i][j] = this->runLengthEncode(denseVoxels);
		}
	}
}




double getVoxelValue(const std::size_t& i, const std::size_t& j, const std::size_t& k) {
	const auto it = std::lower_bound(this->sparseVoxelGrid[i][j].begin(), this->sparseVoxelGrid[i][j].end(), k);
	const auto type = it->getType();
	if (type == VOXVAL_PARTIAL) {
		if (it->getIndex() == k) return it->getValue();
	}
	else if (type == VOXVAL_ONE) {
		if (it->getStartIndex() <= k && k <= it->getEndIndex()) return 1.0;
	}
	return 0.0;
}



