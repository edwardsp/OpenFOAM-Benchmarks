#!/bin/bash

name=$1
size=$2
ppn_list=$3
node_list=$4
ncpus=$5
nnuma=$6
slot_type=$7

source $HOME/OpenFOAM/setenv.sh

mydir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd $mydir

mesh_id=$(qsub -N "mesh_${name}" -l select=1:slot_type=${slot_type}:ncpus=${ncpus}:mpiprocs=$(( $ncpus / 2 )),place=scatter:excl -- $(pwd)/submit_mesh.sh $name "$size" $nnuma | cut -d'.' -f1)

for ppn in $ppn_list; do

    for nodes in $node_list; do

        decompose_id=$(qsub -N "decompose_${name}_${nodes}x${ppn}" -l select=1:slot_type=${slot_type}:ncpus=${ncpus}:mpiprocs=$(( $ncpus / 2 )),place=scatter:excl -W depend=afterok:${mesh_id} -- $(pwd)/submit_decompose.sh $name $nodes $ppn | cut -d'.' -f1)
        presolver_id=$(qsub -N "presolver_${name}_${nodes}x${ppn}" -l select=${nodes}:slot_type=${slot_type}:ncpus=${ncpus}:mpiprocs=${ppn},place=scatter:excl -W depend=afterok:${decompose_id} -- $(pwd)/submit_presolver.sh $name $nnuma | cut -d'.' -f1)
        qsub -N "solver_${name}_${nodes}x${ppn}" -l select=${nodes}:slot_type=${slot_type}:ncpus=${ncpus}:mpiprocs=${ppn},place=scatter:excl -W depend=afterok:${presolver_id} -- $(pwd)/submit_solver.sh $name $nnuma

    done

done
