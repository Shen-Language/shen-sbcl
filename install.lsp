"Copyright (c) 2010-2015, Mark Tarver

All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
3. The name of Mark Tarver may not be used to endorse or promote products
   derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY Mark Tarver ''AS IS'' AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL Mark Tarver BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."

; Assumes *.kl files are in the ./klambda directory
; Creates shen[.exe] file in the current directory
; Creates *.native files in the ./Native directory
; Creates and deletes *.fasl and *.intermed files
;     in the current directory over the course of running

(ENSURE-DIRECTORIES-EXIST "./Native/")

(PROCLAIM '(OPTIMIZE (DEBUG 0) (SPEED 3) (SAFETY 3)))
(DECLAIM (SB-EXT:MUFFLE-CONDITIONS SB-EXT:COMPILER-NOTE))
(SETF SB-EXT:*MUFFLED-WARNINGS* T)
(IN-PACKAGE :CL-USER)

(SETF (READTABLE-CASE *READTABLE*) :PRESERVE)
(SETQ *language* "Common Lisp")
(SETQ *implementation* (LISP-IMPLEMENTATION-TYPE))
(SETQ *release* (LISP-IMPLEMENTATION-VERSION))
(SETQ *port* 2.0)
(SETQ *porters* "Mark Tarver")
(SETQ *os* (SOFTWARE-TYPE))

(DEFUN boot (File)
  (LET* ((KlCode (openfile File))
         (LispCode (MAPCAR (FUNCTION (LAMBDA (X) (shen.kl-to-lisp NIL X))) KlCode))
         (LspFile (FORMAT NIL "~A.lsp" File)))
    (IF (PROBE-FILE LspFile) (DELETE-FILE LspFile))
    (writefile LspFile LispCode)))

(DEFUN writefile (File Out)
  (WITH-OPEN-FILE
    (OUTSTREAM File
      :DIRECTION         :OUTPUT
      :IF-EXISTS         :OVERWRITE
      :IF-DOES-NOT-EXIST :CREATE)
    (FORMAT OUTSTREAM "~%")
    (MAPC (FUNCTION (LAMBDA (X) (FORMAT OUTSTREAM "~S~%~%" X))) Out)
    File))

(DEFUN openfile (File)
  (WITH-OPEN-FILE (In File :DIRECTION :INPUT)
    (DO ((R T) (Rs NIL))
        ((NULL R) (NREVERSE (CDR Rs)))
        (SETQ R (READ In NIL NIL))
        (PUSH R Rs))))

(DEFUN sbcl-install (KlFile)
  (LET* ((KlPath       (FORMAT NIL "./klambda/~A" KlFile))
         (IntermedFile (FORMAT NIL "~A.intermed" KlFile))
         (LspFile      (FORMAT NIL "~A.lsp" IntermedFile))
         (FaslFile     (FORMAT NIL "~A.fasl" IntermedFile))
         (Read         (read-in-kl KlPath)))
    (write-out-kl IntermedFile Read)
    (boot IntermedFile)
    (COMPILE-FILE LspFile)
    (LOAD FaslFile)
    (DELETE-FILE IntermedFile)
    (move-file LspFile)
    (DELETE-FILE FaslFile)))

(DEFUN move-file (Lisp)
  (LET ((Rename (native-name Lisp)))
    (IF (PROBE-FILE Rename) (DELETE-FILE Rename))
    (RENAME-FILE Lisp Rename)))

(DEFUN native-name (Lisp)
  (FORMAT NIL "Native/~{~C~}.native" (nn-h (COERCE Lisp 'LIST))))

(DEFUN nn-h (Lisp)
  (IF (NOT (CHAR-EQUAL (CAR Lisp) #\.))
    (CONS (CAR Lisp) (nn-h (CDR Lisp)))))

(DEFUN read-in-kl (File)
  (WITH-OPEN-FILE
    (In File :DIRECTION :INPUT)
    (kl-cycle (READ-CHAR In NIL NIL) In NIL 0)))

(DEFUN kl-cycle (Char In Chars State)
  (COND
    ((NULL Char)
     (REVERSE Chars))
    ((AND (MEMBER Char '(#\: #\; #\,) :TEST 'CHAR-EQUAL) (= State 0))
     (kl-cycle (READ-CHAR In NIL NIL) In (APPEND (LIST #\| Char #\|) Chars) State))
    ((CHAR-EQUAL Char #\")
     (kl-cycle (READ-CHAR In NIL NIL) In (CONS Char Chars) (flip State)))
    (T
     (kl-cycle (READ-CHAR In NIL NIL) In (CONS Char Chars) State))))

(DEFUN flip (State) (IF (ZEROP State) 1 0))

(COMPILE 'read-in-kl)
(COMPILE 'kl-cycle)
(COMPILE 'flip)

(DEFUN write-out-kl (File Chars)
  (WITH-OPEN-FILE
    (Out File
      :DIRECTION         :OUTPUT
      :IF-EXISTS         :OVERWRITE
      :IF-DOES-NOT-EXIST :CREATE)
    (FORMAT Out "~{~C~}" Chars)))

(COMPILE 'write-out-kl)

(DEFUN import (File)
  (LET ((SourceFile   (FORMAT NIL "~A.lsp" File))
        (CompiledFile (FORMAT NIL "~A.fasl" File)))
    (COMPILE-FILE SourceFile)
    (LOAD CompiledFile)
    (DELETE-FILE CompiledFile)))

(import "primitives")
(import "backend")

(MAPC 'sbcl-install
      '("toplevel.kl"
        "core.kl"
        "sys.kl"
        "sequent.kl"
        "yacc.kl"
        "reader.kl"
        "prolog.kl"
        "track.kl"
        "load.kl"
        "writer.kl"
        "macros.kl"
        "declarations.kl"
        "types.kl"
        "t-star.kl"))

(import "overwrite")
(load "platform.shen")

(MAPC 'FMAKUNBOUND '(boot writefile openfile))

(SAVE-LISP-AND-DIE
  (IF (FIND :WIN32 *FEATURES*) "shen.exe" "shen")
  :EXECUTABLE T
  :SAVE-RUNTIME-OPTIONS T
  :TOPLEVEL 'SHEN-TOPLEVEL)
