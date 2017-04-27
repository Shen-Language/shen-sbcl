set Version=20.0

set UrlRoot=https://github.com/Shen-Language/shen-sources/releases/download
set ReleaseName=shen-%Version%
set FileName=ShenOSKernel-%Version%.zip
set NestedFolderName=ShenOSKernel-%Version%

powershell.exe -Command "Invoke-WebRequest -Uri $Env:UrlRoot/$Env:ReleaseName/$Env:FileName -OutFile .\$Env:FileName" || goto fail
powershell.exe -Command "Expand-Archive .\$Env:FileName -DestinationPath ." || goto fail
del .\kernel /q /s /f
ren %NestedFolderName% kernel
del %FileName% /q /f
exit /b

fail:
exit /b %ERRORLEVEL%
