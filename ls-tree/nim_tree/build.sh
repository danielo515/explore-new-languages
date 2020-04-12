#!/bin/bash
# you can pass --run as first arg to this build script, and the rest of params will be forwarded to
# the program being built
set -x
nim compile --out="$(pwd)/bin/nim-tree" $1 src/nim_tree.nim "${@:2}"