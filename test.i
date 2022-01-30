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

#include "stir/recon_buildblock/ProjMatrixByBinUsingRayTracing.h"
#include "stir/ExamInfo.h"
#include "stir/ProjDataInMemory.h"

#include "matrix.h"
%}
 /* Include numpy support */
#if defined(SWIGPYTHON)
%include "numpy.i"
#endif


%rename(FBP2DReconstructor) sirf::xSTIR_FBP2DReconstruction;
%rename(clone) sirf::DataContainer::my_clone;
// %rename(fill) sirf::STIRImageData::from_array; this will cause trouble


%init %{
#if defined(SWIGPYTHON)
  // numpy support
  import_array();
   #include <numpy/ndarraytypes.h>
#endif
%}

 /* Solve std::unique_ptr issue by ignoring some functions using it */
%ignore *::clone;
%ignore *::conjugate;
%extend sirf::DataContainer
{
  DataContainer * my_clone() const
  { 
    return (*self).clone().get();
  }
}

%newobject *::my_clone();

 /* Ignore unwanted classes to avoid errors */
%ignore sirf::STIRImageData::zoom_image;
%ignore sirf::ListmodeToSinograms;
%ignore sirf::PETScatterEstimator;
%ignore sirf::xSTIR_GeneralisedPrior3DF;
%ignore sirf::xSTIR_GeneralisedObjectiveFunction3DF;
%ignore sirf::xSTIR_IterativeReconstruction3DF;
%ignore sirf::PETAcquisitionModelUsingParallelproj;

 /* Include essential files and solve shared_ptr issue(matlab branch doesn't have std_array.i yet) */
%include "std_string.i"
%include "std_vector.i"
%include "std_map.i"
%include "std_shared_ptr.i"
#if defined(SWIGPYTHON)
  %include "std_array.i"
#endif
%shared_ptr(sirf::DataContainer)
%shared_ptr(sirf::ImageData)
%shared_ptr(sirf::PETImageData)
%shared_ptr(sirf::STIRImageData)
%shared_ptr(sirf::PETAcquisitionData)
%shared_ptr(sirf::PETAcquisitionDataInFile)
%shared_ptr(sirf::PETAcquisitionDataInMemory)
%shared_ptr(sirf::MathClass)

 /* Ignore unwanted classes to avoid errors */
%ignore sirf::PETAcquisitionData::get_empty_segment_by_sinogram;
%ignore sirf::PETAcquisitionData::get_segment_by_sinogram;
%ignore sirf::PETAcquisitionData::set_segment;


%newobject *::dimensions;

// Give names to some templated types used by SIRF (e.g. in VoxelisedGeometricalInfo)
#if defined(SWIGPYTHON)
%template(ArrayInt3D) std::array<int, 3>;
%template(Index3D) std::array<unsigned int, 3>;
%template(Coordinate) std::array<float, 3>;
%template(DirectionMatrix) std::array<std::array<float, 3>, 3>;
#endif

/* Some share_ptr that would be used */
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

 /* Include SIRF headers*/
%include "sirf/common/ImageData.h"
%include "sirf/common/PETImageData.h"
%include "sirf/STIR/stir_types.h"
%include "sirf/STIR/stir_data_containers.h"
%include "sirf/STIR/stir_x.h"
%include "test.h"

 /* Extend STIRImageData class with more features */
%extend sirf::STIRImageData
{
  #if defined(SWIGPYTHON)
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
  #endif

  %feature("docstring", "set dimensions etc") initialise;
  void initialise(int dimension_0, int dimension_1, int dimension_2,
                  float vsize_0 = 1.F, float vsize_1 = 1.F, float vsize_2 = 1.F,
                  float origin_0 = 0.F, float origin_1 = 0.F, float origin_2 = 0.F)
  {
    stir::shared_ptr<sirf::Voxels3DF>
      v_sptr(new sirf::Voxels3DF(IndexRange3D(0, dimension_0 - 1,
                                        -(dimension_1 / 2), -(dimension_1 / 2) + dimension_1 - 1,
                                        -(dimension_2 / 2), -(dimension_2 / 2) + dimension_2 - 1),
                                 sirf::Coord3DF(origin_0, origin_1, origin_2),
                                 sirf::Coord3DF(vsize_0, vsize_1, vsize_2)));
    self->set_data_sptr(v_sptr);
    self->set_up_geom_info();
    self->fill(0.F);
  }
  
  #if defined(SWIGPYTHON)
  void from_array(PyObject *p)
  {
    if (!PyArray_Check(p))
    {
        std::cout << "[C++ Error] wrong type" << std::endl;
        return;
    }
    sirf::Dimensions sirf_dims = self->dimensions();
    npy_intp dims[3];
    dims[0]=sirf_dims["z"];
    dims[1]=sirf_dims["y"];
    dims[2]=sirf_dims["x"];
    PyArrayObject *pcont = PyArray_GETCONTIGUOUS((PyArrayObject *)p);
    npy_intp first_ind[3] = {0,0,0};
    float const *data_ptr = reinterpret_cast<float const *>(PyArray_GetPtr(pcont, first_ind));
    std::copy(data_ptr, data_ptr + (dims[0]*dims[1]*dims[2]), self->begin());
  }
  #endif

  #if defined(SWIGMATLAB)
  mxArray* as_array() const
  {
    sirf::Dimensions sirf_dims = self->dimensions();
    mwSize dims[3];
    dims[0]=sirf_dims["z"];
    dims[1]=sirf_dims["y"];
    dims[2]=sirf_dims["x"];

    // code is based on MATLAB examples, e.g. in MATLAB do
    // edit([matlabroot '/extern/examples/refbook/arrayFillSetPr.c']);
#if MX_HAS_INTERLEAVED_COMPLEX
    typedef mxFloat matlab_float;
#else
    typedef double matlab_float; // WARNING; currently using double, as otherwise mxSetPr fails
#endif
    auto data = (matlab_float *)mxMalloc(dims[0]*dims[1]*dims[2] * sizeof(matlab_float));

    // copy the SIRF data
    // std::copy needs really recent version of STIR, so we'll use a loop
    //std::copy(self->begin(), self->end(), data);
    {
      auto sirfiter = self->begin(); 
      auto dataiter = data;
      while (sirfiter != self->end())
        {
          *dataiter = *sirfiter;
          ++sirfiter;
          ++dataiter;
        }
    }
    // Create a zero-sized array. we'll add data to add below
    mwSize zero_dims[3] = {0,0,0};
    auto mx_array =
      mxCreateNumericArray(3, zero_dims, mxSINGLE_CLASS, mxREAL);
    // Put the C array into the mxArray and define its dimensions
#if MX_HAS_INTERLEAVED_COMPLEX
    mxSetSingles(mx_array, data);
#else
    mxSetPr(mx_array, data);
#endif
    mxSetDimensions(mx_array, dims, 3);
    // Do not call mxFree(dynamicData) because mx_array points to dynamicData
    return mx_array;
  }
  %newobject as_array();
#endif
}

 /* Extend PETAcquisitionData classes with more features */
%extend sirf::PETAcquisitionDataInFile
{
  std::string get_info() const
  {
    return self->data()->get_proj_data_info_sptr()->parameter_info();
  }
}



%extend sirf::PETAcquisitionDataInMemory
{
  /// constructor that takes a scanner name and some data characteristics
  /* Note that adding a constructor in SWIG is more like adding a static member function return a pointer */
  PETAcquisitionDataInMemory(const std::string& scanner_name, int span=1, int max_ring_diff=-1, int view_mash_factor=1)
  {
    stir::shared_ptr<stir::ExamInfo> sptr_ei(new stir::ExamInfo());
    sptr_ei->imaging_modality = stir::ImagingModality::PT;
    stir::shared_ptr<stir::ProjDataInfo> sptr_pdi =
      sirf::PETAcquisitionData::proj_data_info_from_scanner
			(scanner_name, span, max_ring_diff, view_mash_factor);
    auto ptr = new sirf::PETAcquisitionDataInMemory(sptr_ei, sptr_pdi);
    ptr->fill(0.0f);
    return ptr;
  }

  std::string get_info() const
  {
    return self->data()->get_proj_data_info_sptr()->parameter_info();
  }
}
%feature("docstring", "return a string describing the geometry of the data") sirf::PETAcquisitionDataInFile::get_info;
%feature("docstring", "return a string describing the geometry of the data") sirf::PETAcquisitionDataInMemory::get_info;
