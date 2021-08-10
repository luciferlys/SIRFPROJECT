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
%ignore sirf::PETAcquisitionData;

%include "std_string.i"
%include "std_vector.i"
%include "std_shared_ptr.i"



%include "sirf/common/DataContainer.h"
%include "sirf/common/GeometricalInfo.h"
%include "sirf/common/ImageData.h"
%include "sirf/common/PETImageData.h"
%include "sirf/STIR/stir_types.h"


%include "sirf/STIR/stir_data_containers.h"
%include "test.h"
