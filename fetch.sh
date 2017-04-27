#!/bin/sh
set -e

Version=20.0

UrlRoot=https://github.com/Shen-Language/shen-sources/releases/download
ReleaseName=shen-$Version
FileName=ShenOSKernel-$Version.tar.gz
NestedFolderName=ShenOSKernel-$Version

wget $UrlRoot/$ReleaseName/$FileName
tar xf $FileName
rm -rf ./kernel/
mv $NestedFolderName ./kernel/
rm -f $FileName
