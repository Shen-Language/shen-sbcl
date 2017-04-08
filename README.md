[![Shen Version](https://img.shields.io/badge/shen-20.0-blue.svg)](https://github.com/Shen-Language)
[![Build Status](https://travis-ci.org/rkoeninger/shen-sbcl.svg?branch=master)](https://travis-ci.org/rkoeninger/shen-sbcl)

# Shen SBCL

[Shen](http://www.shenlanguage.org) on [Steel Bank Common Lisp](http://www.sbcl.org/) by [Mark Tarver](http://marktarver.com/).

This SBCL port is often considered the de-facto standard implementation of the Shen language. It is also the fastest known port, running the standard test suite in 5-10 seconds, depending on hardware.

## Install

Copy `klambda/*` into this directory, and load `install.lsp` into sbcl.

Example:

```
$ cp klambda/* .
$ sbcl < install.lsp
This is SBCL 1.3.16, an implementation of ANSI Common Lisp.
More information about SBCL is available at <http://www.sbcl.org/>.

<.... snip, lots of output ....>

(boot writefile openfile)
* [undoing binding stack and other enclosing state... done]
[defragmenting immobile space... 647+16144+28641+18823 objects... done]
[saving current Lisp image into Shen.exe:
writing 4816 bytes from the read-only space at 0x20000000
writing 3216 bytes from the static space at 0x20100000
writing 2109440 bytes from the immobile space at 0x20300000
writing 12984432 bytes from the immobile space at 0x21b00000
writing 34635776 bytes from the dynamic space at 0x1000000000
done]
```

This will generate a `Shen.exe` binary in the current directory.
