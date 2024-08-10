#!/bin/bash

if [ $# -ne 1 ]
then
    echo "Usage: $0 <appname>"
    exit 1
fi
APPNAME=${1}

if [ ! -d workspace/${APPNAME} ]
then
    echo "ERROR: not found dir: workspace/${APPNAME}"
    exit 1
fi
cd workspace/run

../../athrill-target-v850e2m/cmake-build/athrill2 \
    -c1 \
    -m memory.txt \
    -d device_config.txt\
    -i \
    ../${APPNAME}/test_main.elf
