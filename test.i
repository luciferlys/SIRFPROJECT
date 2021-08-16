%module ala
%{
#define SWIG_FILE_WITH_INIT

 /* Include the following headers in the wrapper code */
#include <string>
#include <list>
#include <cstdio> 
#include <sstream>
#include <iterator>
#include <memory>
#include <stdlib.h>
#include <chrono>
#include <fstream>
#include <exception>
#include <algorithm>
#include <array>
#include "test.h"

#include "sirf/common/DataContainer.h"
#include "sirf/STIR/stir_data_containers.h"
#include "sirf/STIR/stir_x.h"
  
%}

#if defined(SWIGPYTHON)
%include "numpy.i"
#endif

%init %{
#if defined(SWIGPYTHON)
  // numpy support
  import_array();
   #include <numpy/ndarraytypes.h>
#endif
%}

%ignore *::clone;
%extend sirf::DataContainer
{
  DataContainer * my_clone() const
  { 
    return (*self).clone().get();
  }
}

%newobject *::my_clone();


%ignore sirf::STIRImageData::zoom_image;
%ignore sirf::ListmodeToSinograms;
%ignore sirf::PETScatterEstimator;
%ignore sirf::xSTIR_GeneralisedPrior3DF;
%ignore sirf::xSTIR_GeneralisedObjectiveFunction3DF;
%ignore sirf::xSTIR_IterativeReconstruction3DF;


%include "std_string.i"
%include "std_vector.i"
%include "std_map.i"
%include "std_array.i"
%include "std_shared_ptr.i"
%shared_ptr(sirf::DataContainer)
%shared_ptr(sirf::ImageData)
%shared_ptr(sirf::PETImageData)
%shared_ptr(sirf::STIRImageData)
%shared_ptr(sirf::PETAcquisitionData)
%shared_ptr(sirf::PETAcquisitionDataInFile)
%shared_ptr(sirf::PETAcquisitionDataInMemory)
%shared_ptr(sirf::MathClass)



%ignore sirf::PETAcquisitionData::get_empty_segment_by_sinogram;
%ignore sirf::PETAcquisitionData::get_segment_by_sinogram;
%ignore sirf::PETAcquisitionData::set_segment;


%newobject *::dimensions;

// Give names to some templated types used by SIRF (e.g. in VoxelisedGeometricalInfo)
%template(ArrayInt3D) std::array<int, 3>;
%template(Index3D) std::array<unsigned int, 3>;
%template(Coordinate) std::array<float, 3>;
%template(DirectionMatrix) std::array<std::array<float, 3>, 3>;
%shared_ptr(sirf::GeometricalInfo<3, 3>);
%shared_ptr(sirf::VoxelisedGeometricalInfo<3>);
%shared_ptr(sirf::VoxelisedGeometricalInfo<3>::TransformMatrix);
// ignore due to SWIG bug with int-templates
%ignore *::calculate_index_to_physical_point_matrix;

%include "sirf/common/GeometricalInfo.h"

%include "sirf/common/DataContainer.h"

%template(GeometricalInfo3D) sirf::GeometricalInfo<3, 3>;
%template(VoxelisedGeometricalInfo3D) sirf::VoxelisedGeometricalInfo<3>;
#%template(TransformMatrix3D) sirf::VoxelisedGeometricalInfo<3>::TransformMatrix;

%include "sirf/common/ImageData.h"
%include "sirf/common/PETImageData.h"
%include "sirf/STIR/stir_types.h"
%include "sirf/STIR/stir_data_containers.h"
%include "sirf/STIR/stir_x.h"
%include "test.h"

%extend sirf::STIRImageData
{
  PyObject* as_array() const
  {
    sirf::Dimensions sirf_dims = self->dimensions();
    npy_intp dims[3];
    dims[0]=sirf_dims["z"];
    dims[1]=sirf_dims["y"];
    dims[2]=sirf_dims["x"];
    auto np_array =
      (PyArrayObject *)PyArray_SimpleNew(3, dims, NPY_FLOAT);
    auto dtype = PyArray_DescrFromType(NPY_FLOAT);
    auto iter = NpyIter_New(np_array, NPY_ITER_READONLY, NPY_KEEPORDER, NPY_NO_CASTING, dtype);
    if (iter==NULL) {
        return NULL;
    }
    auto iternext = NpyIter_GetIterNext(iter, NULL);
    auto dataptr = (float **) NpyIter_GetDataPtrArray(iter);
    auto sirfiter = self->begin();
    do {
    **dataptr = *sirfiter;
    ++sirfiter; }
    while (iternext(iter));
    return PyArray_Return(np_array);
  }
  %newobject as_array();

  %feature("autodoc", "set dimemnsions etc") initialise;
  void initialise(VoxelisedGeometricalInfo<3>::Size dimensions,
                  VoxelisedGeometricalInfo<3>::Coordinate vsize = {1.F, 1.F, 1.F},
                  VoxelisedGeometricalInfo<3>::Coordinate origin = {0.F, 0.F, 0.F})
  {
    stir::shared_ptr<sirf::Voxels3DF>
      v_sptr(new sirf::Voxels3DF(IndexRange3D(0, dimensions[0] - 1,
                                        -(dimensions[1] / 2), -(dimensions[1] / 2) + dimensions[1] - 1,
                                        -(dimensions[2] / 2), -(dimensions[2] / 2) + dimensions[2] - 1),
                                 sirf::Coord3DF(origin[0], origin[1], origin[2]),
                                 sirf::Coord3DF(vsize[0], vsize[1], vsize[2])));
    self->set_data_sptr(v_sptr);
    self->set_up_geom_info();
    self->fill(0.F);
  }
}
