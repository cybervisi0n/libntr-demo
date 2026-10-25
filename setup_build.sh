#!/bin/bash

# Usage: setup_build.sh {target}
target=$1

case $target in
    prospero)
        ./scripts/download_prospero_dependencies.sh
        meson setup build_$target -Dbuild_target=$target --cross-file $PS5_PAYLOAD_SDK/toolchain/prospero.ini
        ;;
    *)
        meson setup build_$target -Dbuild_target=$target
        ;;
esac
