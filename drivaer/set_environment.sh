#!/bin/bash

# set paths for OpenFOAM and environment
source $HOME/OpenFOAM/setenv.sh

procs=$(foamDictionary paramDict -entry nProcs -value)
mpirun_flags="-np $procs"