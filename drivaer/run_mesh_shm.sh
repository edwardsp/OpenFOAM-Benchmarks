#!/bin/bash

procs=4

foamCleanTutorials
rm -rf 0 > /dev/null 2>&1
#cp -r 0_org 0 > /dev/null 2>&1

surfaceFeatureExtract | tee log.surfaceFeatureExtract
blockMesh | tee log.blockMesh

decomposePar
mpirun -np $procs snappyHexMesh -parallel -overwrite | tee log.shm
mpirun -np $procs checkMesh -parallel | tee log.checkmesh

reconstructParMesh -constant
rm -rf 0 > /dev/null 2>&1
cp -r 0_org 0 > /dev/null 2>&1

foamDictionary constant/polyMesh/boundary -entry entry0.ffminx.type -set patch
foamDictionary constant/polyMesh/boundary -entry entry0.ffmaxx.type -set patch
foamDictionary constant/polyMesh/boundary -entry entry0.ffminy.type -set symmetry
foamDictionary constant/polyMesh/boundary -entry entry0.ffmaxy.type -set patch
foamDictionary constant/polyMesh/boundary -entry entry0.ffminz.type -set wall
foamDictionary constant/polyMesh/boundary -entry entry0.ffmaxz.type -set patch

foamDictionary constant/polyMesh/boundary -entry entry0.ffminx.inGroups -remove
foamDictionary constant/polyMesh/boundary -entry entry0.ffmaxx.inGroups -remove
foamDictionary constant/polyMesh/boundary -entry entry0.ffminy.inGroups -remove
foamDictionary constant/polyMesh/boundary -entry entry0.ffmaxy.inGroups -remove
foamDictionary constant/polyMesh/boundary -entry entry0.ffminz.inGroups -remove
foamDictionary constant/polyMesh/boundary -entry entry0.ffmaxz.inGroups -remove

decomposePar -force

#checkMesh | tee log.checkmesh
