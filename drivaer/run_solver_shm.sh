#!/bin/bash

procs=4

mpirun -np $procs renumberMesh -parallel -overwrite | tee log.renumber

mpirun -np $procs potentialFoam -parallel -writep | tee log.potential

mpirun -np $procs simpleFoam -parallel | tee log.solver
