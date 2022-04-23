#!/bin/sh
set -eu

ACME=${PLAN9}/bin/acme
ACME_AUX=$HOME/.acme

CGO_CFLAGS="-I/usr/local/include/"
CGO_LDFLAGS="-L/usr/local/lib"

MANPATH=$PLAN9/man export MANPATH
PATH=${PLAN9}/bin:$PATH export PATH

pgrep plumber >/dev/null || plumber

BUTMOD=0x4c7899ff

TXTFG=0xd0d0d0ff
TXTBG=0x1c1c1cff
TXTBG=0x121212ff

TXTHLFG=$TXTFG
TXTHLBG=0x285577ff

#TAGFG=0x9e9e9eff
TAGFG=$BUTMOD
TAGBG=0x121212ff
TAGBG=0x1c1c1cff
TAGHLFG=$TAGBG
TAGHLBG=$TAGFG

B2HL=0x400000ff
B3HL=0x004000ff

if [ "${0##*/}" = "acmebright" ]; then
. /home/fabian/src/acme-scripts/solarized-bright.theme
fi

if [ "${0##*/}" = "acmedark" ]; then
. /home/fabian/src/acme-scripts/solarized-dark.theme
fi

#	-f /mnt/font/GoMono/10a/font

if [ "${0##*/}" = "acmedark" ] || [ "${0##*/}" = "acmebright" ]; then
	TEMPLATE=$(printf '%s' \
		"textback:$TXTBG,"\
		"texthigh:$TXTHLBG,"\
		"textbord:$TXTBORD,"\
		"texttext:$TXTFG,"\
		"texthtext:$TXTHLFG,"\
		"tagback:$TAGBG,"\
		"taghigh:$TAGHLBG,"\
		"tagbord:$TAGBORD,"\
		"tagtext:$TAGFG,"\
		"taghtext:$TAGHLFG,"\
		"butmod:$BUTMOD,"\
		"butcol:$BUTCOL,"\
		"but2col:$B2HL,"\
		"but3col:$B3HL")

	SHELL=${PLAN9}/bin/rc $ACME -c 1 -a -M \
			-f ${PLAN9}/font/fixed/unicode.9x15.font \
			-t "$TEMPLATE" \
			"$@" $ACME_AUX/guide
else
	SHELL=${PLAN9}/bin/rc $ACME -c 1 -a -M \
		-f ${PLAN9}/font/fixed/unicode.9x15.font \
		"$@" $ACME_AUX/guide
fi
