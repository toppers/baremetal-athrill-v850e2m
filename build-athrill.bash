#!/bin/bash

if [ $# -eq 1 ]
then
    echo "Cleaning athrill binary"
    if [ -d athrill-target-v850e2m/cmake-build ]
    then
        rm -rf athrill-target-v850e2m/cmake-build
    fi
    exit 0
fi

if [ -d athrill-target-v850e2m/cmake-build ]
then
    :
else
    mkdir athrill-target-v850e2m/cmake-build
fi
cd athrill-target-v850e2m/cmake-build
cmake ..
make

./athrill2
if [ $? -eq 0 ]
then
    echo "OK: athrill2 is created on `pwd`/athrill2"
else
    echo "ERROR: can not create athrill2"
    exit 1
fi

exit 0