cmake_minimum_required(VERSION 3.1.0)


PROJECT(swigtest)

SET_PROPERTY(GLOBAL PROPERTY USE_FOLDERS ON)


# set default build-type to Release
if(NOT CMAKE_BUILD_TYPE)
   set(CMAKE_BUILD_TYPE "Release" CACHE STRING "type of build: Debug Release RelWithDebInfo MinSizeRel." FORCE)
endif()
FIND_PACKAGE(SIRF REQUIRED)
FIND_PACKAGE(STIR REQUIRED)
add_library(libtest test.cxx)
target_link_libraries(libtest sirf::cstir)

# Comment out testmain temporarily due to errors
#add_executable(testmain testmain.cxx)
#target_link_libraries(testmain libtest ${STIR_LIBRARIES})


FIND_PACKAGE(SWIG 3.0 REQUIRED)
INCLUDE("${SWIG_USE_FILE}")

include_directories(${CMAKE_SOURCE_DIR})

#include_directories(${BOOST_ROOT})

get_target_property(SIRF_INCLUDE_DIRS  sirf::cstir INTERFACE_INCLUDE_DIRECTORIES)
message(STATUS "SIRF_INCLUDE_DIRS: ${SIRF_INCLUDE_DIRS}")
SET_SOURCE_FILES_PROPERTIES(test.i PROPERTIES
  CPLUSPLUS ON
  INCLUDE_DIRECTORIES "${SIRF_INCLUDE_DIRS}")


find_package(PythonInterp)
FIND_PACKAGE(PythonLibs REQUIRED)
INCLUDE_DIRECTORIES(${PYTHON_INCLUDE_PATH})
FIND_PACKAGE(Numpy REQUIRED)
INCLUDE_DIRECTORIES(${NUMPY_INCLUDE_DIRS})

# Make MATLAB support available
FIND_PACKAGE(Matlab COMPONENTS MX_LIBRARY REQUIRED)
matlab_get_mex_suffix("${Matlab_ROOT_DIR}" Matlab_MEX_EXT)
message(STATUS "Found Matlab_LIBRARIES: ${Matlab_LIBRARIES}")
message(STATUS "Found Matlab_INCLUDE_DIRS: ${Matlab_INCLUDE_DIRS}")

if (STIR_WITH_Parallelproj_PROJECTOR)
	SET(CMAKE_SWIG_FLAGS -DSTIR_WITH_Parallelproj_PROJECTOR)
endif()

# Comment out -doxygen option for matlab
#if(SWIG_VERSION GREATER_EQUAL 4.0)
#      SET(CMAKE_SWIG_FLAGS ${CMAKE_SWIG_FLAGS} -doxygen)
#endif()


  # TODO probably better to call the module stirpy or something
  # TODO -builtin option only appropriate for python
  # while the next statement sets it for all modules called test
  #SET(SWIG_MODULE_test_EXTRA_FLAGS -builtin )
  SWIG_ADD_LIBRARY(ala LANGUAGE python TYPE MODULE SOURCES test.i ${STIR_REGISTRIES})
  SET(CMAKE_SWIG_FLAGS ${CMAKE_SWIG_FLAGS} -mexname alaMATLAB_wrap)
  SWIG_ADD_LIBRARY(alaMATLAB LANGUAGE matlab TYPE MODULE SOURCES test.i ${STIR_REGISTRIES})
  #SWIG_WORKAROUND(${SWIG_MODULE_ala_REAL_NAME})
  SWIG_LINK_LIBRARIES(ala libtest sirf::cstir ${STIR_LIBRARIES} ${PYTHON_LIBRARIES})
  SWIG_LINK_LIBRARIES(alaMATLAB libtest sirf::cstir ${STIR_LIBRARIES} ${Matlab_LIBRARIES})
  #target_link_libraries(${SWIG_MODULE_ala_REAL_NAME})

  #if (BUILD_SWIG_MATLAB)
  SET_TARGET_PROPERTIES(${SWIG_MODULE_alaMATLAB_REAL_NAME} PROPERTIES
	  SUFFIX "_wrap.${Matlab_MEX_EXT}" PREFIX "${MATLAB_PREFIX}"
        LINK_FLAGS "${Matlab_CXXLINKER_FLAGS}"
        FOLDER "Matlab")
  set(MATLAB_DEST ${CMAKE_INSTALL_PREFIX}/matlab CACHE PATH "Destination for Matlab module (relative to CMAKE_INSTALL_PREFIX)")
  INSTALL(TARGETS ${SWIG_MODULE_alaMATLAB_REAL_NAME} DESTINATION ${MATLAB_DEST})
  INSTALL(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/+ala DESTINATION ${MATLAB_DEST})
  file(GLOB SwigMatlabFiles "${CMAKE_CURRENT_BINARY_DIR}/Swig*.m")
  INSTALL(FILES ${SwigMatlabFiles} DESTINATION ${MATLAB_DEST})
  #endif (BUILD_SWIG_MATLAB)

  set(PYTHON_DEST ${CMAKE_INSTALL_PREFIX}/python CACHE PATH "Destination for python module")
  INSTALL(TARGETS ${SWIG_MODULE_ala_REAL_NAME} DESTINATION ${PYTHON_DEST})
  INSTALL(FILES ${CMAKE_CURRENT_BINARY_DIR}/ala.py  DESTINATION ${PYTHON_DEST})
  



