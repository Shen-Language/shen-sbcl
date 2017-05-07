# Deprecated

**This repo is no longer being actively maintained. It has been superceded by [shen-cl](https://github.com/Shen-Language/shen-cl).**

[![Shen Version](https://img.shields.io/badge/shen-20.0-blue.svg)](https://github.com/Shen-Language)
[![Build Status](https://travis-ci.org/Shen-Language/shen-sbcl.svg?branch=master)](https://travis-ci.org/Shen-Language/shen-sbcl)

# Shen SBCL

[Shen](http://www.shenlanguage.org) on [Steel Bank Common Lisp](http://www.sbcl.org/) by [Mark Tarver](http://marktarver.com/), with contributions by the [Shen Language Open Source Community](https://github.com/Shen-Language).

This SBCL port is often considered the de-facto standard implementation of the Shen language. It is also the fastest known port, running the standard test suite in 5-10 seconds, depending on hardware.

Fetch the kernel sources by running `./fetch.sh`/`fetch.bat`. This will download the [shen-sources](https://github.com/Shen-Language/shen-sources) release into a folder named `kernel`.

Build by running `build.sh`/`build.bat`. This will generate the `shen`/`shen.exe` executable. If the `kernel` folder is not present, `fetch` will be called first.

Start the Shen REPL by running the executable.

Shen files can be specified on the command line, in which case they will be run sequentially and the REPL will not be started by default. The REPL can still be started by invoking `(shen.shen)`.

The test suite can be run by running `./shen testsuite.shen`/`shen.exe testsuite.shen`.
