#!/bin/bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* ./build-aux

set -exuo pipefail

touch doc/jemalloclocal.html
touch doc/jemalloclocal.3

export CXXFLAGS="-std=c++14"
export EXTRA_CONFIGURE_ARGS="--with-jemalloc-prefix=local --with-install-suffix=local --enable-prof"
$RECIPE_DIR/build-jemalloc.sh
