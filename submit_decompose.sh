#!/bin/bash

cd $PBS_O_WORKDIR

CASE_NAME="$1"
NODES="$2"
PPN="$3"

# set paths for OpenFOAM and environment
source $HOME/OpenFOAM/setenv.sh

rsync -av --exclude constant $CASE_NAME/. ${CASE_NAME}_${NODES}x${PPN}

cd ${CASE_NAME}_${NODES}x${PPN}
ln -s ../${CASE_NAME}/constant

foamDictionary paramDict -entry nProcs -set $(( $NODES * $PPN ))

. run_decompose.sh
