#!/bin/bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* ./build-aux

set -e
set -x

# Static TLS has caused users to experience some errors of the form
# "libjemalloc.so.2: cannot allocate memory in static TLS block"
#
# We disable this feature until we better understand how to avoid loader errors
# of this type
if [[ ${target_platform} =~ linux.* ]]; then
  # Fixes:
  #  * As conda-forge/anaconda patches the glibc headers to have an inline
  #    aligned_alloc implementation, we need to mangle aligned_alloc to use
  #    a separate name, we cannot override it.
  #  * With the old glibc version/headers, we also run into
  #    https://github.com/jemalloc/jemalloc/issues/1237
  ./configure --prefix=$PREFIX \
              --disable-static \
              --disable-tls \
              --with-mangling=aligned_alloc:__aligned_alloc \
              --disable-initial-exec-tls
else
  ./configure --prefix=$PREFIX \
              --disable-static \
              --disable-tls
fi
make -j${CPU_COUNT}
make install
