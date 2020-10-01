#!/bin/bash

mkdir /mnt/resource/OpenFOAM
cd $HOME
ln -s /mnt/resource/OpenFOAM

cd OpenFOAM

git clone https://github.com/OpenFOAM/OpenFOAM-8.git
git clone https://github.com/OpenFOAM/ThirdParty-8.git

cat <<EOF >setenv.sh
source /etc/profile
MY_DIR="\$( cd "\$( dirname "\${BASH_SOURCE[0]}" )" && pwd )"
export MODULEPATH="/opt/hpcx-v2.6.0-gcc-MLNX_OFED_LINUX-5.0-1.0.0.0-redhat7.7-x86_64/modulefiles:\$MODULEPATH"
export PATH="/opt/gcc-9.2.0/bin:\$PATH"
export LD_LIBRARY_PATH="/opt/gcc-9.2.0/lib64:\$LD_LIBRARY_PATH"
module load hpcx
. \$MY_DIR/OpenFOAM-8/etc/bashrc
EOF

source setenv.sh

cd OpenFOAM-8

./Allwmake -j 120 2>&1 | tee build.log

cd $HOME

rm OpenFOAM
mv /mnt/resource/OpenFOAM .

