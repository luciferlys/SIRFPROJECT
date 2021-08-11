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
#include "test.h"

#include "sirf/common/DataContainer.h"
#include "sirf/STIR/stir_data_containers.h"
#include "sirf/STIR/stir_x.h"
  
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
%ignore sirf::PETAcquisitionSensitivityModel;
%ignore sirf::PETAcquisitionModel;
%ignore sirf::PETScatterEstimator;
%ignore sirf::PETAcquisitionModelUsingMatrix;
%ignore sirf::xSTIR_GeneralisedPrior3DF;
%ignore sirf::xSTIR_GeneralisedObjectiveFunction3DF;
%ignore sirf::xSTIR_IterativeReconstruction3DF;
%ignore sirf::xSTIR_FBP2DReconstruction::set_up;
%ignore sirf::xSTIR_FBP2DReconstruction::process;

%include "std_string.i"
%include "std_vector.i"
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


%include "sirf/common/DataContainer.h"
%include "sirf/common/GeometricalInfo.h"
%include "sirf/common/ImageData.h"
%include "sirf/common/PETImageData.h"
%include "sirf/STIR/stir_types.h"
%include "sirf/STIR/stir_data_containers.h"
%include "sirf/STIR/stir_x.h"
%include "test.h"