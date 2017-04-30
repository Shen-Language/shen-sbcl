#!/bin/sh
set -e

if [ ! -d "./kernel/" ]; then
    ./fetch.sh
fi

sbcl --load install.lsp
