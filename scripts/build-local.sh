#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"
FFMPEG_DIR="$PARENT_DIR/ffmpeg"

BUILD_DIR="$PARENT_DIR/ffmpeg_build"

if [ -d "$BUILD_DIR" ]; then
  read -p "Directory $BUILD_DIR exists. Do you want to delete it? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf "$BUILD_DIR"
  else
    exit 1
  fi
fi

mkdir -p "$BUILD_DIR"

PKG_CONFIG_PATH="$BUILD_DIR/lib/pkgconfig"

sudo apt-get update
sudo apt-get install nasm

cd "$FFMPEG_DIR"

./configure \
  --prefix="$BUILD_DIR" \
  --pkg-config-flags="--static" \
  --extra-cflags="-I$BUILD_DIR/build/include" \
  --extra-ldflags="-L$BUILD_DIR/build/lib" \
  --extra-libs="-lpthread -lm" \
  --ld="g++" \
  --bindir="$BUILD_DIR/out/bin" \
  --enable-gpl \
  --enable-gnutls \
  --enable-libaom \
  --enable-libass \
  --enable-libfdk-aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libvorbis \
  --enable-libx264 \
  --enable-nonfree

make -j$(nproc)
make install
hash -r
