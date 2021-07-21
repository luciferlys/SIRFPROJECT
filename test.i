%module test
%{
#define SWIG_FILE_WITH_INIT

 /* Include the following headers in the wrapper code */
#include <string>
#include <list>
#include <cstdio> // for size_t
#include <sstream>
#include <iterator>

#include "test.h"
  
%}

%include "test.h"
