#!/bin/bash

cases=()
cases+=("drivaer_s:220 20 32:60 90 120:1 2 4 8 16")
cases+=("drivaer_m:440 40 64:60 90 120:1 2 4 8 16")
cases+=("drivaer_l:660 60 96:60 90 120:1 2 4 8 16")

for i in $(seq 0 $(( ${#cases[@]} - 1 ))); do

    name="$(cut -d':' -f1 <<< ${cases[$i]})"
    size="$(cut -d':' -f2 <<< ${cases[$i]})"
    ppn_list="$(cut -d':' -f3 <<< ${cases[$i]})"
    node_list="$(cut -d':' -f4 <<< ${cases[$i]})"

    mesh_id=$(qsub -N "mesh_${name}" -l select=1:ncpus=120:mpiprocs=60,place=scatter:excl -- $(pwd)/submit_mesh.sh $name "$size" | cut -d'.' -f1)

    for ppn in $ppn_list; do

        for nodes in $node_list; do

            decompose_id=$(qsub -N "decompose_${name}_${nodes}x${ppn}" -l select=1:ncpus=120:mpiprocs=60,place=scatter:excl -W depend=afterok:${mesh_id} -- $(pwd)/submit_decompose.sh $name $nodes $ppn | cut -d'.' -f1)
            presolver_id=$(qsub -N "presolver_${name}_${nodes}x${ppn}" -l select=${nodes}:ncpus=120:mpiprocs=${ppn},place=scatter:excl -W depend=afterok:${decompose_id} -- $(pwd)/submit_presolver.sh $name | cut -d'.' -f1)
            qsub -N "solver_${name}_${nodes}x${ppn}" -l select=${nodes}:ncpus=120:mpiprocs=${ppn},place=scatter:excl -W depend=afterok:${presolver_id} -- $(pwd)/submit_solver.sh $name

        done

    done

done
