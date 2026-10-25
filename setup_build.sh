#!/bin/bash

# Usage: setup_build.sh {target}

meson setup build_linux -Dbuild_target=$1
