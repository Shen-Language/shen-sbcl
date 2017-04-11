if not exist "Native" mkdir Native
cp -R klambda\* .
sbcl --load install.lsp
