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

%extend MathClass {
MathClass operator* (const MathClass& b)
{
  Mathclass c(*this);
  c.multiply(*this,b));
  return c;
}
}
/* with this %extend feature, the error message was Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: unsupported operand type(s) for *: 'MathClass' and 'MathClass'*/

#if defined(SWIGPYTHON)
%rename(__len__) sirf::DataContainer::items;
%rename(__mult__) sirf::DataContainer::multiply;
/* %rename(operator*) sirf::DataContainer::multiply; */
#endif
/* using %rename, the error message was Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: unsupported operand type(s) for *: 'MathClass' and 'MathClass'*/
%include "DataContainer.h"
%include "test.h"
