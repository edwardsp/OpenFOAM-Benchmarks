#!/bin/bash

cd $PBS_O_WORKDIR

CASE_NAME="$1"
BLOCKMESH_DIMENSIONS="$2"
NUM_NUMA=$3

# set paths for OpenFOAM and environment
source $HOME/OpenFOAM/setenv.sh

CORES=$(cat $PBS_NODEFILE | wc -l)
PPN=$(cat $PBS_NODEFILE | uniq -c | head -1 | awk '{ print $1 }')
NODES=$(sort -u < $PBS_NODEFILE | wc -l)

rsync -av drivaer/. $CASE_NAME
cd $CASE_NAME

foamDictionary paramDict -entry nProcs -set $CORES
foamDictionary paramDict -entry blockMeshCells -set "(${BLOCKMESH_DIMENSIONS})"

ranks_per_numa=$(( (($PPN-1)/${NUM_NUMA}) + 1 ))

procs=$(foamDictionary paramDict -entry nProcs -set ${CORES})
mpirun_flags="-np $CORES -hostfile $PBS_NODEFILE $(env |grep FOAM | cut -d'=' -f1 | sed 's/^/-x /g' | tr '\n' ' ') -x MPI_BUFFER_SIZE --report-bindings --map-by ppr:${ranks_per_numa}:numa"

. run_mesh.sh
