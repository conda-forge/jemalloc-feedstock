#!/bin/bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* ./build-aux

set -exuo pipefail

touch doc/jemalloclocal.html
touch doc/jemalloclocal.3

export EXTRA_CONFIGURE_ARGS="--disable-cxx --with-jemalloc-prefix=local --with-install-suffix=local"
$RECIPE_DIR/build-jemalloc.sh
