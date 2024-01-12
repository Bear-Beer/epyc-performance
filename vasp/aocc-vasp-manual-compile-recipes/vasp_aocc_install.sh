#!/bin/bash
set -x
echo "Starting VASP Build script"
ENV_FILE=$PWD/env_vasp_aocc.sh
source $ENV_FILE
if [[ -d $VASPROOT ]]; then
	echo "VASP - File Exists "
else
	cd $SOURCES
	if [[ ! -e "$VASP_TARBALL" ]]; then
		echo "Please Download target VASP tarball file: $VASP_TARBALL"
		exit 1
	fi

	tar -xzvf ${SOURCES}/${VASP_TARBALL}
fi
cd $VASPROOT
echo "creating the Makefile for VASP"
# $*$(FUFFIX) $*$(SUFFIX) $(CPP_OPTIONS)
echo "########################################################################

# Default precompiler options
CPP_OPTIONS ?= -DHOST=\\\"LinuxGNU\\\" \\
	-DMPI -DMPI_BLOCK=8000 -Duse_collective \\
	-DscaLAPACK \\
	-DCACHE_SIZE=4000 \\
	-Davoidalloc -Dvasp6 -Duse_bse_te -Dtbdyn -Dfock_dblbuf -D_OPENMP \\
	-Dshmem_bcast_buffer -Duse_shmem -Dsysv -Dfftw_cache_plans \\
	-Duse_fftw_plan_effort -DNGZhalf 

CPP         = flang -E -Mfree -C -w \$*\$(FUFFIX) >\$*\$(SUFFIX) \$(CPP_OPTIONS)

FC          = mpif90 -fopenmp 
FCL         = mpif90 -fopenmp

FREE        = -ffree-form -ffree-line-length-none

FFLAGS      = -w -fno-fortran-main -Mbackslash

OFLAG       = -O3 
OFLAG_IN    = \$(OFLAG)
DEBUG       = -O0

OBJECTS     = fftmpiw.o fftmpi_map.o fftw3d.o fft3dlib.o
OBJECTS_O1 += fftw3d.o fftmpi.o fftmpiw.o
OBJECTS_O2 += fft3dlib.o

# For what used to be vasp.5.lib
CPP_LIB     = \$(CPP)
FC_LIB      = \$(FC)
CC_LIB=clang
CFLAGS_LIB = -O3
FFLAGS_LIB = -O3
FREE_LIB    = \$(FREE)

OBJECTS_LIB ?= linpack_double.o getshmem.o

# For the parser library
CXX_PARS    = clang++
LLIBS = -lstdc++ fftlib/fftlib.o -ldl

##
## Customize as of this point! Of course you may change the preceding
## part of this file as well if you like, but it should rarely be
## necessary ...
##

# When compiling on the target machine itself, change this to the
# relevant target when cross-compiling for another architecture

VASP_TARGET_CPU ?= -march=${ARCH} -mtune=${ARCH}
FFLAGS     += \$(VASP_TARGET_CPU)

# BLAS (mandatory)
AOCL_HOME   = ${AOCL_HOME}
AMDBLIS_ROOT ?= \$(AOCL_HOME)
BLAS ?= -L\${AMDBLIS_ROOT}/lib -lblis-mt

# LAPACK (mandatory)
AMDLIBFLAME_ROOT ?= \$(AOCL_HOME)
LAPACK ?= -L\${AMDLIBFLAME_ROOT}/lib -lflame

# scaLAPACK (mandatory)
AMDSCALAPACK_ROOT ?= \$(AOCL_HOME)
SCALAPACK ?=  -L\${AMDSCALAPACK_ROOT}/lib -lscalapack

LLIBS      += \$(SCALAPACK) \$(LAPACK) \$(BLAS) -lalm

# FFTW (mandatory)
AMDFFTW_ROOT  ?= \$(AOCL_HOME)
LLIBS      += -L\$(AMDFFTW_ROOT)/lib -lfftw3 -lfftw3_omp
INCS       += -I\$(AMDFFTW_ROOT)/include

# HDF5-support (optional but strongly recommended)
#CPP_OPTIONS+= -DVASP_HDF5
#HDF5_ROOT  ?= /path/to/your/hdf5/installation
#LLIBS      += -L\$(HDF5_ROOT)/lib -lhdf5_fortran
#INCS       += -I\$(HDF5_ROOT)/include

# For the VASP-2-Wannier90 interface (optional)
#CPP_OPTIONS    += -DVASP2WANNIER90
#WANNIER90_ROOT ?= /path/to/your/wannier90/installation
#LLIBS          += -L\$(WANNIER90_ROOT)/lib -lwannier
	
# For the fftlib library (recommended)
#CPP_OPTIONS+= -Dsysv
#FCL        += fftlib.o
CXX_FFTLIB  = mpicxx -fopenmp -std=c++11 -DFFTLIB_THREADSAFE
INCS_FFTLIB = -I./include -I\$(AMDFFTW_ROOT)/include
LIBS       += fftlib
LLIBS      += -ldl  -lmpi -lmpi_usempif08 -lmpi_mpifh " > makefile.include

cat makefile.include
echo "starting make for vasp"
cd ${VASPROOT}
#make DEPS=1 -j8 std 2>&1|tee make.log
make DEPS=1 -j8 std 2>&1|tee make.log
cd $VASPROOT/bin/
if [[ -e "vasp_std" ]]; then
	echo "VASP Build SUCCESSFUL"
else
	echo "VASP Build FAILED"
fi
