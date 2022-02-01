# Automatic Generation of MATLAB Interfaces to the C++ Synergistic Image Reconstruction Framework

### This is a course project module used as part of the UCL MSc Scientific and Data Intensive Computing.

## Installation

This project is based on a SIRF VM installed from http://www.ccpsynerbi.ac.uk/downloads.

SWIG and SIRF-SuperBuild needed in this project have already been provided in the SIRF VM downloaded from the official website of SIRF.

### SWIG
SWIG used in this project can be pulled from Prof. Kris Thielemans's Github repository https://github.com/KrisThielemans/swig/tree/matlab-update. Official version of SWIG does not supported MATLAB yet so an experimental version of SWIG should be used.

### SIRF SuperBuild
```bash
cd ~/devel/SIRF-SuperBuild
git pull
```
Using this would give you the updated version of SIRF.

### My project
```bash
cd ~/devel
git clone https://github.com/luciferlys/SIRFPROJECT.git
```
Copy the project from Yisu Lu's git repository.

## Build Instructions

### SWIG
```bash
sudo apt install automake
sudo apt install bison
sudo apt install python-dev
cd ~/swig
git remote add Kris-SWIG https://github.com/KrisThielemans/swig
git pull Kris-SWIG matlab-update
./autogen.sh
./configure --prefix=/home/sirfuser
make
make install
```

### SIRF
```bash
cd ~/devel/SIRF-SuperBuild
git checkout master
git pull
cd ~/devel/buildVM
cmake .
make
make install
```
More information about how to correctly set some entries in CMake, check https://github.com/SyneRBI/SIRF-SuperBuild/blob/master/README.md

To get the ```+ala``` module (an automatic generated MATLAB interface to SIRF) running, you have to get and build this project.

To get a successful build of the project, some CMake entries may need to be set:

```bash
CMAKE_INSTALL_PREFIX=/somewhere/your/home/directory/install
Matlab_ROOT_DIR=.../MATLAB/R2021a(or version of your MATLAB)
STIR_DIR=(where your STIRConfig.cmake at)
SIRF_DIR=(where your SIRFConfig.cmake at)
SWIG_EXECUTABLE=(where you installed the SWIG with MATLAB support)
```

You can test the functionalities wrapped in this project using ```test_functionality.m```.
