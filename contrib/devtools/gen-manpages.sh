#!/usr/bin/env bash

export LC_ALL=C
TOPDIR=${TOPDIR:-$(git rev-parse --show-toplevel)}
BUILDDIR=${BUILDDIR:-$TOPDIR}

BINDIR=${BINDIR:-$BUILDDIR/src}
MANDIR=${MANDIR:-$TOPDIR/doc/man}

VEKTORCOIND=${VEKTORCOIND:-$BINDIR/vektorcoind}
VEKTORCOINCLI=${VEKTORCOINCLI:-$BINDIR/vektorcoin-cli}
VEKTORCOINTX=${VEKTORCOINTX:-$BINDIR/vektorcoin-tx}
VEKTORCOINQT=${VEKTORCOINQT:-$BINDIR/qt/vektorcoin-qt}

[ ! -x $VEKTORCOIND ] && echo "$VEKTORCOIND not found or not executable." && exit 1

# The autodetected version git tag can screw up manpage output a little bit
VEKTORVER=($($VEKTORCOINCLI --version | head -n1 | awk -F'[ -]' '{ print $6, $7 }'))

# Create a footer file with copyright content.
# This gets autodetected fine for vektorcoind if --version-string is not set,
# but has different outcomes for vektorcoin-qt and vektorcoin-cli.
echo "[COPYRIGHT]" > footer.h2m
$VEKTORCOIND --version | sed -n '1!p' >> footer.h2m

for cmd in $VEKTORCOIND $VEKTORCOINCLI $VEKTORCOINTX $VEKTORCOINQT; do
  cmdname="${cmd##*/}"
  help2man -N --version-string=${VEKTORVER[0]} --include=footer.h2m -o ${MANDIR}/${cmdname}.1 ${cmd}
  sed -i "s/\\\-${VEKTORVER[1]}//g" ${MANDIR}/${cmdname}.1
done

rm -f footer.h2m
