#!/bin/bash

ncpus=$1

source $HOME/OpenFOAM/setenv.sh

mydir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd $mydir

job_id=$(qsub -N "build_openfoam" -l select=1:ncpus=${ncpus}:mpiprocs=${ncpus},place=scatter:excl -- $(pwd)/build_openfoam8.sh | cut -d'.' -f1)

if qstat -f $job_id 2>&1 |grep finished; then 
    sleep 10
fi
