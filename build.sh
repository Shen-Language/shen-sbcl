#!/bin/sh

cp -R klambda/. .
sbcl --load install.lsp
