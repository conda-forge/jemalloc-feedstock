#!/bin/bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* ./build-aux

set -exuo pipefail

# Static TLS has caused users to experience some errors of the form
# "libjemalloc.so.2: cannot allocate memory in static TLS block"
#
# We disable this feature until we better understand how to avoid loader errors
# of this type
if [[ ${target_platform} =~ linux.* ]]; then
  if [[ ${target_platform} == linux-ppc64le ]]; then
    EXTRA_CONFIGURE_ARGS="--with-lg-page=16"
  fi

  # Fixes:
  #  * As conda-forge/anaconda patches the glibc headers to have an inline
  #    aligned_alloc implementation, we need to mangle aligned_alloc to use
  #    a separate name, we cannot override it.
  #  * With the old glibc version/headers, we also run into
  #    https://github.com/jemalloc/jemalloc/issues/1237
  ./configure --prefix=${PREFIX} \
              --disable-static \
              --disable-tls \
              --disable-initial-exec-tls \
	      ${EXTRA_CONFIGURE_ARGS:---with-mangling=aligned_alloc:__aligned_alloc}
elif [[ "${target_platform}" == "osx-arm64" ]]; then
  ./configure --prefix=${PREFIX} \
              --disable-static \
              --with-lg-page=14 \
	      ${EXTRA_CONFIGURE_ARGS:-}
else
  ./configure --prefix=${PREFIX} \
              --disable-static \
              --disable-tls \
	      ${EXTRA_CONFIGURE_ARGS:-}
fi
make -j${CPU_COUNT}
make install


if [[ "${PKG_NAME}" == lib* ]]; then
  rm ${PREFIX}/bin/jemalloc-config
  rm ${PREFIX}/bin/jeprof
  rm ${PREFIX}/bin/jemalloc.sh
  rm ${PREFIX}/lib/pkgconfig/jemalloc.pc
fi
