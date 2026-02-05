#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm   \
    doxygen               \
    ffmpeg                \
    fluidsynth            \
    freepats-general-midi \
    lua                   \
    lua-lpeg              \
    lua-filesystem        \
    pipewire-alsa         \
    pipewire-audio        \
    pipewire-jack         \
    rtmidi                \
    sdl2                  \
    sdl2_mixer

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package

# If the application needs to be manually built that has to be done down here
echo "Making nightly build of Snes9x-GTK..."
echo "---------------------------------------------------------------"
REPO="https://github.com/CorsixTH/CorsixTH"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone "$REPO" ./CorsixTH
echo "$VERSION" > ~/version

cd ./CorsixTH
mkdir -p build && cd build
cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DLUA_PROGRAM_PATH=/usr/bin/lua \
    -DLUA_INCLUDE_DIR=/usr/include \
    -DLUA_LIBRARY=/usr/lib/liblua.so \
    -Wno-dev
make -j$(nproc)
make install
