#!/bin/bash
mkdir build_win64/libntr-demo_win64
cp build_win64/main.exe build_win64/libntr-demo_win64/main.exe
cp -u /ucrt64/bin/SDL2.dll build_win64/libntr-demo_win64/SDL2.dll
cp -u /ucrt64/bin/libwinpthread-1.dll build_win64/libntr-demo_win64/libwinpthread-1.dll
cp -u /ucrt64/bin/libenet-7.dll build_win64/libntr-demo_win64/libenet-7.dll
cp -u /ucrt64/bin/libgcc_s_seh-1.dll build_win64/libntr-demo_win64/libgcc_s_seh-1.dll
cp -u /ucrt64/bin/libstdc++-6.dll build_win64/libntr-demo_win64/libstdc++-6.dll
