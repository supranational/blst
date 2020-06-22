#!/bin/sh

HERE=`dirname $0`
cd "${HERE}"
for pl in ../src/asm/*-x86_64.pl; do
    s=`basename $pl .pl`.asm
    (set -x; ${PERL:-perl} $pl masm > win64/$s)
    s=`basename $pl .pl`.s
    (set -x; ${PERL:-perl} $pl elf > elf/$s)
    (set -x; ${PERL:-perl} $pl mingw64 > coff/$s)
    (set -x; ${PERL:-perl} $pl macosx > mach-o/$s)
done

