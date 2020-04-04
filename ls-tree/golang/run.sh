#!/usr/bin/env bash

if [ ! -f go-ls ]; then
    ./build.sh
fi
./go-ls ../
