#!/bin/bash

source set_environment.sh

mpirun $mpirun_flags simpleFoam -parallel 2>&1 | tee log.simpleFoam
