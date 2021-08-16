cmake_minimum_required(VERSION 3.1.0)


PROJECT(swigtest)

SET_PROPERTY(GLOBAL PROPERTY USE_FOLDERS ON)


# set default build-type to Release
if(NOT CMAKE_BUILD_TYPE)
   set(CMAKE_BUILD_TYPE "Release" CACHE STRING "type of build: Debug Release RelWithDebInfo MinSizeRel." FORCE)
endif()
FIND_PACKAGE(SIRF REQUIRED)

add_library(libtest test.cxx)
target_link_libraries(libtest sirf::cstir)

add_executable(testmain testmain.cxx)
target_link_libraries(testmain libtest ${STIR_LIBRARIES})


FIND_PACKAGE(SWIG 3.0 REQUIRED)
INCLUDE("${SWIG_USE_FILE}")

include_directories(${CMAKE_SOURCE_DIR})

#include_directories(${BOOST_ROOT})

get_target_property(SIRF_INCLUDE_DIRS  sirf::cstir INTERFACE_INCLUDE_DIRECTORIES)
message(STATUS "SIRF_INCLUDE_DIRS: ${SIRF_INCLUDE_DIRS}")
SET_SOURCE_FILES_PROPERTIES(test.i PROPERTIES
  CPLUSPLUS ON
  INCLUDE_DIRECTORIES "${SIRF_INCLUDE_DIRS}")

if(SWIG_VERSION GREATER_EQUAL 4.0)
      SET(CMAKE_SWIG_FLAGS "${CMAKE_SWIG_FLAGS} -doxygen")
endif()

find_package(PythonInterp)
FIND_PACKAGE(PythonLibs REQUIRED)
INCLUDE_DIRECTORIES(${PYTHON_INCLUDE_PATH})
FIND_PACKAGE(Numpy REQUIRED)
INCLUDE_DIRECTORIES(${NUMPY_INCLUDE_DIRS})

SET(CMAKE_SWIG_FLAGS "${CMAKE_SWIG_FLAGS} -DSTIR_WITH_Parallelproj_PROJECTOR")

  # TODO probably better to call the module stirpy or something
  # TODO -builtin option only appropriate for python
  # while the next statement sets it for all modules called test
  #SET(SWIG_MODULE_test_EXTRA_FLAGS -builtin )
  SWIG_ADD_LIBRARY(ala LANGUAGE python TYPE MODULE SOURCES test.i ${STIR_REGISTRIES})
  #SWIG_WORKAROUND(${SWIG_MODULE_ala_REAL_NAME})
  SWIG_LINK_LIBRARIES(ala libtest sirf::cstir ${STIR_LIBRARIES} ${PYTHON_LIBRARIES})
  #target_link_libraries(${SWIG_MODULE_ala_REAL_NAME})

  set(PYTHON_DEST ${CMAKE_INSTALL_PREFIX}/python CACHE PATH "Destination for python module")
  INSTALL(TARGETS ${SWIG_MODULE_ala_REAL_NAME} DESTINATION ${PYTHON_DEST})
  INSTALL(FILES ${CMAKE_CURRENT_BINARY_DIR}/ala.py  DESTINATION ${PYTHON_DEST})


  



