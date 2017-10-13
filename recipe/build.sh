#!/bin/bash

set -e
set -x

./autogen.sh
./configure --prefix=$PREFIX
# Skip doc generation as the required docbook XSLs are not yet packaged on conda-forge
touch doc/jemalloc.html
touch doc/jemalloc.3
make -j${CPU_COUNT}
make install
