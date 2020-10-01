#!/bin/bash

mpirun $mpirun_flags renumberMesh -parallel -overwrite 2>&1 | tee log.renumberMesh

mpirun $mpirun_flags potentialFoam -parallel -writep 2>&1 | tee log.potentialFoam

