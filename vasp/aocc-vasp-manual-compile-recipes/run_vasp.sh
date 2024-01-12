#!/bin/bash
#SBATCH --job-name=vasp_si256_aocc
#SBATCH --nodes=1
#SBATCH --partition=genoa_all
#SBATCH --output=VASP-Si256_aocc.%j

ENV_FILE=$PWD/vasp_aocc_env.sh
source $ENV_FILE

# Si256 dataset is available with VASP source at testsuite/tests/Si256_VJT_HSE06
cd ${VASPROOT}/testsuite/tests/Si256_VJT_HSE06
 
# Steps to setup the input files for run
cp INCAR.1.STD INCAR
cp ${VASPROOT}/testsuite/POTCARS/POTCAR.Si256_VJT_HSE06 POTCAR
 

# Mapping of process to hardware resources
export NUM_CORES=$(nproc)
export OMP_NUM_THREADS=8
NUM_MPI_RANKS=$(( $NUM_CORES / $OMP_NUM_THREADS ))

# Running VASP
mpirun -np $NUM_MPI_RANKS --map-by ppr:1:l3cache:pe=$OMP_NUM_THREADS $VASPROOT/bin/vasp_std
