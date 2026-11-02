#!/bin/bash
#
# Build athrill2 from the sibling checkouts ../athrill and
# ../athrill-target-v850e2m (the Hakoniwa Business Pack layout).
# Missing checkouts are cloned next to this repository.
#
# Usage: bash build-athrill.bash          build
#        bash build-athrill.bash clean    remove the build directory

ROOT_DIR=$(cd "$(dirname "$0")" && pwd)
PARENT_DIR=$(dirname "${ROOT_DIR}")
ATHRILL_DIR=${PARENT_DIR}/athrill
TARGET_DIR=${PARENT_DIR}/athrill-target-v850e2m
BUILD_DIR=${ROOT_DIR}/cmake-build

if [ $# -eq 1 ]
then
    echo "Cleaning athrill binary"
    rm -rf "${BUILD_DIR}"
    exit 0
fi

for repo in athrill athrill-target-v850e2m
do
    if [ ! -d "${PARENT_DIR}/${repo}" ]
    then
        git clone "https://github.com/toppers/${repo}.git" "${PARENT_DIR}/${repo}" || exit 1
    fi
done

cmake -S "${TARGET_DIR}" -B "${BUILD_DIR}" \
    -DCMAKE_BUILD_TYPE=Release \
    -DATHRILL_SOURCE_DIR="${ATHRILL_DIR}" || exit 1
cmake --build "${BUILD_DIR}" || exit 1

"${BUILD_DIR}/athrill2"
if [ $? -eq 0 ]
then
    echo "OK: athrill2 is created on ${BUILD_DIR}/athrill2"
else
    echo "ERROR: can not create athrill2"
    exit 1
fi

exit 0
