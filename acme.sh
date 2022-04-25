#!/bin/sh
set -eu

ACME=${PLAN9}/bin/acme
ACME_AUX=${HOME}/.acme

# CGO_CFLAGS="-I/usr/local/include/"
# CGO_LDFLAGS="-L/usr/local/lib"

MANPATH=$PLAN9/man export MANPATH
PATH=${PLAN9}/bin:$PATH export PATH

pgrep plumber >/dev/null || plumber

if [ "${0##*/}" = "acmebright" ]; then
. ${ACME_AUX}/solarized-bright.theme
fi

if [ "${0##*/}" = "acmedark" ]; then
. ${ACME_AUX}/solarized-dark.theme
fi

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
