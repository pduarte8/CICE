#!/bin/bash

# Fram





module purge
module load StdEnv
#module load netCDF-Fortran/4.5.2-iompi-2019b
#module load netCDF-Fortran/4.5.3-iompi-2020b
#module load netCDF-Fortran/4.5.2-iompi-2020a
module load netCDF-Fortran/4.5.3-iompi-2020b
export I_MPI_F90=ifort


#intel 2018a

#module purge
#module load StdEnv
#module load intel/2018a
#module load netCDF-Fortran/4.4.4-intel-2018a-HDF5-1.8.19
#export I_MPI_F90=ifort

