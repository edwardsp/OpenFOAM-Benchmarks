#!/bin/bash

mpirun $mpirun_flags simpleFoam -parallel 2>&1 | tee log.simpleFoam
