#!/bin/bash

foamCleanTutorials
rm -rf 0 > /dev/null 2>&1

surfaceFeatures 2>&1 | tee log.surfaceFeatures
blockMesh 2>&1 | tee log.blockMesh

decomposePar
mpirun $mpirun_flags snappyHexMesh -parallel -overwrite 2>&1 | tee log.snappyHexMesh
mpirun $mpirun_flags checkMesh -parallel 2>&1 | tee log.checkMesh

reconstructParMesh -constant 2>&1 | tee log.reconstructParMesh
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

rm -rf processor*
