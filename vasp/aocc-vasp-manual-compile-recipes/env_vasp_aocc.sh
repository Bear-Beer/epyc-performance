#!/bin/bash
echo "Setting the paths for VASP"
###################################################
################## USER SECTIONS ###################
export SOURCES=$PWD

# Set compiler path and name
# Use module or export PATH depending upon your enviornment
export COMPILERHOME=/opt/AMD/aocc-compiler-4.1.0

#Setting up the compiler
export CC=${COMPILERHOME}/bin/clang
export CXX=${COMPILERHOME}/bin/clang++
export FC=${COMPILERHOME}/bin/flang
export F90=${COMPILERHOME}/bin/flang
export F77=${COMPILERHOME}/bin/flang

export AR=${COMPILERHOME}/bin/llvm-ar
export RANLIB=${COMPILERHOME}/bin/llvm-ranlib
export NM=${COMPILERHOME}/bin/llvm-nm

#Set the ARCH as per your Processor model.
export ARCH=znver4 #For AMD 4th Gen EPYC™ Processor

#Setting up the compiler options for Genoa
export CFLAGS="-O3 -fPIC -march=$ARCH -fopenmp "
export CXXFLAGS="-O3 -fPIC -march=$ARCH -fopenmp "
export FCFLAGS="-O3 -fPIC -march=$ARCH -fopenmp "
export FFLAGS="-O3 -fPIC -march=$ARCH -fopenmp "
##################################################################
##################################################################
# Set AOCL library path, 
# Use module or export PATH depending upon your enviornment
export AOCL_HOME=/opt/AMD/aocl/aocl-linux-aocc-4.1.0/aocc
export BLISROOT=${AOCL_HOME}
export LIBFLAMEROOT=${AOCL_HOME}
export SCALAPACKROOT=${AOCL_HOME}
export FFTWROOT=${AOCL_HOME}

### path to vasp source file ###
export VASP_TARBALL="vasp.6.3.2.tgz"
export VASPROOT="$SOURCES/${VASP_TARBALL%.*}"
export VASPSOURCE=/home
##################################################################
##################################################################
# Configuring MPI library
# Use module or export PATH depending upon your enviornment
export OPENMPI_HOME=/opt/openmpi 
export MPICC=${OPENMPI_HOME}/bin/mpicc
export MPICXX=${OPENMPI_HOME}/bin/mpicxx
export MPIFC=${OPENMPI_HOME}/bin/mpifort
export MPIF90=${OPENMPI_HOME}/bin/mpif90
export MPIF77=${OPENMPI_HOME}/bin/mpifort
##################################################################
##################################################################
#Setting env variables
export PATH=${COMPILERHOME}/bin:${AOCL_HOME}/bin:${OPENMPI_HOME}/bin:$PATH
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${COMPILERHOME}/lib:${COMPILERHOME}/lib64:${AOCL_HOME}/lib:${OPENMPI_HOME}/lib:${OPENMPI_HOME}/lib64
export INCLUDE=${INCLUDE}:${COMPILERHOME}/include:${AOCL_HOME}/include:${OPENMPI_HOME}/include
export C_INCLUDE_PATH=${C_INCLUDE_PATH}:${COMPILERHOME}/include:${AOCL_HOME}/include:${OPENMPI_HOME}/include
export CPLUS_INCLUDE_PATH=${CPLUS_INCLUDE_PATH}:${COMPILERHOME}/include:${AOCL_HOME}/include:${OPENMPI_HOME}/include
