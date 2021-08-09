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
  
%}

%ignore sirf::PETAcquisitionData;
%ignore sirf::PETAcquisitionDataInFile;
%ignore sirf::PETAcquisitionDataInMemory;
%ignore sirf::ImageData;
%ignore sirf::Image3DF;
%ignore sirf::Image3DFIterator;
%ignore sirf::Image3DFIterator_const;
%ignore sirf::Voxels3DF;
%ignore sirf::*::clone;
%ignore sirf::STIRImageData::zoom_image;




%include "std_string.i"
%include "sirf/common/DataContainer.h"
%include "sirf/common/ImageData.h"
%include "sirf/common/PETImageData.h"
%include "sirf/STIR/stir_types.h"
%include "sirf/STIR/stir_data_containers.h"
%include "test.h"