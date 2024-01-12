#! /usr/bin/bash
set -x
echo "###################################################################################"
echo "# OpenMPI #"
echo "###################################################################################"
echo "Starting MPI Build script"
ENV_FILE=$PWD/env_vasp_aocc.sh
source $ENV_FILE

#if [[ -d $OPENMPI_HOME ]]; then
#	echo "OpenMPI - File exists"
#else
#cd $SOURCES
#rm -rf openmpi-4.1.4 openmpi
#if [ -e "openmpi-4.1.4.tar.bz2" ]
#then
#break
#else
#echo "Downloading openMPI"
#wget https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.4.tar.bz2
#fi
tar -xvf $SOURCES/openmpi-4.1.4.tar.bz2
cd openmpi-4.1.4
./configure --prefix=$OPENMPI_HOME CC=${CC} CXX=${CXX} FC=${FC} CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" FCFLAGS="${FCFLAGS}" --enable-mpi-fortran --enable-shared=yes --enable-static=yes --enable-mpi1-compatibility --disable-hwloc-pci
if [[ $? -ne 0 ]]; then
	echo "FAILED: in configure phase"
	exit 1
fi

make clean
make -j 2>&1|tee make.log
if [[ $? -ne 0 ]]; then
	echo "FAILED: in make phase"
	exit 1
fi

make install 2>&1| tee make_install.log
if [[ -e $MPICC ]]; then
	echo "OPENMPI Build SUCCESSFUL"
	$MPICC -v
	echo 
else
	echo "OPENMPI Build FAILED"
fi
