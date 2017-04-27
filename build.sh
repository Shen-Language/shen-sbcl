#!/bin/sh
set -e

if [ ! -f "./kernel/" ]; then
    ./fetch.sh
fi

sbcl --load install.lsp
