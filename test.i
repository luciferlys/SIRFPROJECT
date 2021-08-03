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
#include "test.h"
#include "DataContainer.h"
  
%}

%ignore sirf::DataContainer::clone;
%ignore sirf::DataContainer::new_data_container_handle;
%ignore sirf::DataContainer::items;
%ignore sirf::DataContainer::is_complex;
%ignore sirf::DataContainer::norm;
%ignore sirf::DataContainer::dot;
%ignore sirf::DataContainer::axpby;
%ignore sirf::DataContainer::xapyb;
%ignore sirf::DataContainer::write;
%ignore sirf::DataContainer::clone_impl;

#if defined(SWIGPYTHON)
%rename(__len__) sirf::DataContainer::items;
#endif

%include "DataContainer.h"
%include "test.h"