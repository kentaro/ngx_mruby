#!/bin/sh

# Default install
#   download nginx into ./build/
#   build into ./build/nginx

# ENV example
#
#   NGINX_CONFIG_OPT_ENV='--prefix=/usr/local/nginx-1.4.4' NGINX_SRC_ENV='/usr/local/src/nginx-1.4.4' sh build.sh
#

set -e

. ./nginx_version

if [ "$NGINX_CONFIG_OPT_ENV" != "" ]; then
    NGINX_CONFIG_OPT=$NGINX_CONFIG_OPT_ENV
else
    NGINX_CONFIG_OPT='--prefix='`pwd`'/build/nginx --with-http_stub_status_module'
fi

if [ "$NUM_THREADS_ENV" != "" ]; then
    NUM_THREADS=$NUM_THREADS_ENV
else
    NUM_THREADS=$(expr `getconf _NPROCESSORS_ONLN` / 2)
    if [ $NUM_THREADS -eq "0" ]; then
        NUM_THREADS=1
    fi
fi

echo "NGINX_CONFIG_OPT=$NGINX_CONFIG_OPT"
echo "NUM_THREADS=$NUM_THREADS"

if [ ! -d "./mruby/src" ]; then
    echo "mruby Downloading ..."
    git submodule init
    git submodule update
    echo "mruby Downloading ... Done"
fi
cd mruby
if [ -d "./build" ]; then
    echo "mruby Cleaning ..."
    ./minirake clean
    echo "mruby Cleaning ... Done"
fi
cd ..

if [ $NGINX_SRC_ENV ]; then
    NGINX_SRC=$NGINX_SRC_ENV
else
    echo "nginx Downloading ..."
    if [ -d "./build" ]; then
        echo "build directory was found"
    else
        mkdir build
    fi
    cd build
    if [ ! -e ${NGINX_SRC_VER} ]; then
        wget http://nginx.org/download/${NGINX_SRC_VER}.tar.gz
        echo "nginx Downloading ... Done"
        tar xf ${NGINX_SRC_VER}.tar.gz
    fi
    ln -sf ${NGINX_SRC_VER} nginx_src
    NGINX_SRC=`pwd`'/nginx_src'
    cd ..
fi

echo "ngx_mruby configure ..."
./configure --with-ngx-src-root=${NGINX_SRC} --with-ngx-config-opt="${NGINX_CONFIG_OPT}"
echo "ngx_mruby configure ... Done"

echo "mruby building ..."
make build_mruby NUM_THREADS=$NUM_THREADS -j $NUM_THREADS
echo "mruby building ... Done"

echo "ngx_mruby building ..."
make NUM_THREADS=$NUM_THREADS -j $NUM_THREADS
echo "ngx_mruby building ... Done"

echo "build.sh ... successful"

#sudo make install
