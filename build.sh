#!/bin/sh

mkdir -p Native
cp -R klambda/. .
sbcl --load install.lsp

