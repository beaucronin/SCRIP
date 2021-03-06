#-----------------------------------------------------------------------
#
# File:  linuxgfortran.gnu
#
#  Contains compiler and loader options for the Linux OS using the 
#  gfortran compiler that comes with gcc and specifies the serial directory
#  for communications modules.
#
#-----------------------------------------------------------------------

F77 = gfortran
F90 = gfortran
LD = gfortran
CC = gcc
Cp = /bin/cp
Cpp = /lib/cpp -P
AWK = /usr/bin/gawk
ABI = 
COMMDIR = serial
 
#  Enable MPI library for parallel code, yes/no.

MPI = no

# Adjust these to point to where netcdf is installed
NETCDFINC = -I/usr/include
NETCDFLIB = -L/usr/lib/x86_64-linux-gnu -L/usr/lib/x86_64-linux-gnu/hdf5/serial

#  Enable trapping and traceback of floating point exceptions, yes/no.
#  Note - Requires 'setenv TRAP_FPE "ALL=ABORT,TRACE"' for traceback.

TRAP_FPE = no

#------------------------------------------------------------------
#  precompiler options
#------------------------------------------------------------------

#DCOUPL              = -Dcoupled

Cpp_opts =   \
      $(DCOUPL)

Cpp_opts := $(Cpp_opts) -DPOSIX
 
#----------------------------------------------------------------------------
#
#                           C Flags
#
#----------------------------------------------------------------------------
 
CFLAGS = $(ABI) 

ifeq ($(OPTIMIZE),yes)
  CFLAGS := $(CFLAGS) -O -fopenmp
else
  CFLAGS := $(CFLAGS) -g -fopenmp
endif
 
#----------------------------------------------------------------------------
#
#                           FORTRAN Flags
#
#----------------------------------------------------------------------------
 
FBASE = $(ABI) $(NETCDFINC) -I$(DepDir)
MODSUF = mod

ifeq ($(TRAP_FPE),yes)
  FBASE := $(FBASE) 
endif

ifeq ($(OPTIMIZE),yes)
  FFLAGS = $(FBASE) -O3 -fopenmp
else
  FFLAGS = $(FBASE) -g -fopenmp
endif
 
#----------------------------------------------------------------------------
#
#                           Loader Flags and Libraries
#
#----------------------------------------------------------------------------
 
LDFLAGS = $(ABI) -fopenmp

# for netcdf installations which do not have --enable-netcdf4

# LIBS = $(NETCDFLIB) -lnetcdf
 
# if netcdf is configured with --enable-netcdf4 then it also has to 
# be configured with --enable-separate-fortran enabling it to create 
# the libnetcdff.a libs

LIBS = $(NETCDFLIB) -lnetcdf -lnetcdff -lhdf5_hl -lhdf5 -lz

 
ifeq ($(MPI),yes)
  LIBS := $(LIBS) -lmpi 
endif

ifeq ($(TRAP_FPE),yes)
  LIBS := $(LIBS) 
endif
 
#LDLIBS = $(TARGETLIB) $(LIBRARIES) $(LIBS)
LDLIBS = $(LIBS)
 
