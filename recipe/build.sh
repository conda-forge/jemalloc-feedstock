#!/bin/bash

set -e
set -x

# Static TLS has caused users to experience some errors of the form
# "libjemalloc.so.2: cannot allocate memory in static TLS block"
#
# We disable this feature until we better understand how to avoid loader errors
# of this type
./autogen.sh
./configure --prefix=$PREFIX \
            --disable-tls \
            --with-mangling=aligned_alloc:__aligned_alloc
            
# Skip doc generation as the required docbook XSLs are not yet packaged on conda-forge
touch doc/jemalloc.html		             
touch doc/jemalloc.3

# Build
make -j${CPU_COUNT}
make install
