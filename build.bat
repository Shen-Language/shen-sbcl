if not exist ".\kernel" call fetch.bat

sbcl --load install.lsp
