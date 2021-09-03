# Automatic Generation of Python Interfaces to the C++ Synergistic Image Reconstruction Framework
This is a course project module used as part of the UCL MSc Scientific and Data Intensive Computing.
## Installation
To get this ```bash ala ``` module running, you need to install SIRF from https://github.com/SyneRBI/SIRF-SuperBuild First. 
You may also need to install SWIG, boost and CMake to perform SIRF-SuperBuild installation. 
## Usage
Firstly, download swigtest folder. Use CMake to install the SWIG project and get the python module ala.py & _ala.pyd;
Open PowerShell and insert these lines before the next step:
```bash
$install="...\SIRFbuild\INSTALL" (your SIRF location)
 $Env:Path = "${install}\bin" + ";" + $Env:Path
 $Env:Path += ";${install}\FFTW"
 $Env:Path += ";.../boost_1_76_0/lib64-msvc-14.1/" (your boost location)
 $Env:SIRF_PATH = "...\SIRFbuild\sources\SIRF"
 $Env:PYTHONPATH = "${install}\python"
 $Env:MATLABPATH = "${install}\matlab"
 $Env:MATLABPATH+='; ...\SIRFbuild\sources\SPM'
 $Env:Path += ";...\MATLAB\extern\bin\win64; ...\MATLAB\bin\win64" (your MATLAB location)
```
Then please run test_functionality.py to test the ala module. 