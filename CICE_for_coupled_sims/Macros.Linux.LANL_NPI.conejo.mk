#==============================================================================
# Makefile macros for "conejo," Linux cluster at LANL
#==============================================================================

           # First the defaults
#
           FC := ifort
#          FFLAGS := -heap-arrays -fp-model precise 
           FFLAGS := -mcmodel=large -xHOST #-Nmpi
              CPP := /usr/bin/cpp
         CPPFLAGS := -P -traditional
               CC := icc
              CXX := icc
           CFLAGS :=
         CXXFLAGS :=
          LDFLAGS :=
               AR := ar
          ARFLAGS := r
            MKDIR := mkdir -p
               RM := rm -f
           RANLIB := ranlib
             PERL := perl
             TEST := test
#MCT_INCDIR ?= /cluster/work/users/mitya/tmproms/MCT/include
#MCT_LIBDIR ?= /cluster/work/users/mitya/tmproms/MCT/lib

INCLDIR    := -I. -I/usr/include -I$(MCT_INCDIR) -I/cluster/home/mitya/models/Icepack
SLIBS      := -L/usr/lib -L$(MCT_LIBDIR) -lmct -lmpeu
INCLDIR := $(INCLDIR)  -I/cluster/home/mitya/CICE/cicecore/cicedynB/infrastructure 
#SLIBS := $(SLIBS)  -lnetcdff -lnetcdf
#SLIBS   := -L$(LIB_NETCDF) -lnetcdff -lnetcdf
SLIBS := $(SLIBS) -lnetcdff -lnetcdf -L/cluster/home/mitya/CICE/cicecore/cicedynB/infrastructure/  
#-llibice_shr_reprosum86
ULIBS      := 
#CPP        := /usr/bin/cpp
#CPPFLAGS   := -P -traditional
#CPPDEFS    := -DLINUX 
#CFLAGS     := -c -O2

CPP        := fpp
CPPDEFS    := -DFORTRANUNDERSCORE ${ICE_CPPDEFS} -DROMSCOUPLED
CFLAGS     := -c -O2 -fp-model precise   -xHost

ifeq ($(ICE_COMMDIR), mpi)
   #FC         := mpif90
   #CC         := mpicc
   CPPFLAGS += -DMPI
   #ifdef USE_MPIF90
             FC := mpif90
   #          FC := mpiifort
   #          CC := mpicc
   #else
   #          LIBS += -lmpi #-lfmpi
   #endif
#else
#   FC         := ifort
#   CC         := icc
endif



FIXEDFLAGS := -132
FREEFLAGS  := 
#FFLAGS     :=  -w -O2 -ip -convert big_endian -assume byterecl -ftz -mcmodel=large -shared-intel
FFLAGS     := -r8 -i4 -O2 -align all -w -ftz -convert big_endian -assume byterecl -fp-model precise -mcmodel=large
#FFLAGS     := -r8 -i4  -align all -w -ftz -convert big_endian -assume byterecl -fp-model precise -g
#FFLAGS     := -r8 -i4 -align all -w -ftz -convert big_endian -assume byterecl -fpe0 -CB -traceback 
#FFLAGS     := -r8 -i4 -align all -w -ftz -convert big_endian -assume byterecl -fpe0 -CB -check uninit

ifeq ($(THRD), yes)
   FFLAGS  :=  $(FFLAGS) -openmp
#cesm   CPPDEFS :=  $(CPPDEFS) -DTHREADED_OMP
endif

MOD_SUFFIX := mod
LD         := $(FC)
LDFLAGS    := $(FFLAGS) -v

    CPPDEFS :=  $(CPPDEFS) -DNXGLOB=$(NXGLOB) -DNYGLOB=$(NYGLOB) \
                -DBLCKX=$(BLCKX) -DBLCKY=$(BLCKY) -DMXBLCKS=$(MXBLCKS) \
                -DNICELYR=$(NICELYR) -DNSNWLYR=$(NSNWLYR) -DNICECAT=$(NICECAT) \
                -DTRAGE=$(TRAGE) -DTRFY=$(TRFY) -DTRLVL=$(TRLVL) -DTRPND=$(TRPND) \
                -DTRBRI=$(TRBRI) -DNTRAERO=$(NTRAERO) -DTRZS=$(TRZS) \
                -DNBGCLYR=$(NBGCLYR) -DTRALG=$(TRALG) -DTRBGCZ=$(TRBGCZ) \
                -DTRDOC=$(TRDOC) -DTRDOC=$(TRDOC) -DTRDIC=$(TRDIC) \
                -DTRDON=$(TRDON) -DTRFED=$(TRFED) -DTRFEP=$(TRFEP) \
                -DTRZAERO=$(TRZAERO)  \
                -DTRBGCS=$(TRBGCS) -DNUMIN=$(NUMIN) -DNUMAX=$(NUMAX)\
                -DROMSCOUPLED
#   CPPDEFS :=  $(CPPDEFS) -DAOMIP

ifeq ($(DITTO), yes)
   CPPDEFS :=  $(CPPDEFS) -DREPRODUCIBLE
endif
ifeq ($(BARRIERS), yes)
   CPPDEFS :=  $(CPPDEFS) -Dgather_scatter_barrier
endif

ifeq ($(IO_TYPE), netcdf)
   CPPDEFS :=  $(CPPDEFS) -Dncdf
#   INCLDIR := $(INCLDIR) $(NETCDF)/include
#   SLIBS   := $(SLIBS) $(NETCDF)/lib -lnetcdf
#   INCLDIR := $(INCLDIR) -I/usr/projects/climate/SHARED_CLIMATE/software/conejo/netcdf/3.6.3/intel-13.0.1/include
#   SLIBS   := $(SLIBS) -L/usr/projects/climate/SHARED_CLIMATE/software/conejo/netcdf/3.6.3/intel-13.0.1/lib -lnetcdf
#    INCLDIR = $(INCLDIR) 
#    SLIBS += -lnetcdff -lnetcdf 
endif



#FFLAGS += -I$(MCT_INCDIR)
#SLIBS +=  -L$(MCT_LIBDIR) -lmct -lmpeu
#FFLAGS := $(FFLAGS) -I/cluster/work/users/mitya/tmproms/MCT/include
#SLIBS := $(SLIBS) -L/cluster/work/users/mitya/tmproms/MCT/lib -lmct -lmpeu


### if using parallel I/O, load all 3 libraries.  PIO must be first!
ifeq ($(IO_TYPE), pio)
   INCLDIR := $(INCLDIR) -I/usr/projects/climate/SHARED_CLIMATE/software/conejo/pio/1.7.2/intel-13.0.1/openmpi-1.6.3/netcdf-3.6.3-parallel-netcdf-1.3.1/include
   SLIBS   := $(SLIBS) -L/usr/projects/climate/SHARED_CLIMATE/software/conejo/pio/1.7.2/intel-13.0.1/openmpi-1.6.3/netcdf-3.6.3-parallel-netcdf-1.3.1/lib -lpio

   INCLDIR := $(INCLDIR) -I/usr/projects/climate/SHARED_CLIMATE/software/conejo/parallel-netcdf/1.3.1/intel-13.0.1/openmpi-1.6.3/include
   SLIBS   := $(SLIBS) -L/usr/projects/climate/SHARED_CLIMATE/software/conejo/parallel-netcdf/1.3.1/intel-13.0.1/openmpi-1.6.3/lib -lpnetcdf

   CPPDEFS :=  $(CPPDEFS) -Dncdf
   INCLDIR := $(INCLDIR) -I/usr/projects/climate/SHARED_CLIMATE/software/conejo/netcdf/3.6.3/intel-13.0.1/include
   SLIBS   := $(SLIBS) -L/usr/projects/climate/SHARED_CLIMATE/software/conejo/netcdf/3.6.3/intel-13.0.1/lib -lnetcdf

endif
