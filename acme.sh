#!/bin/sh
set -eu

SCRIPT_DIR=$(dirname "$(readlink -f $0)")

# Namespace superseeds DISPLAY
NAMESPACE=/tmp/ns.acme.p9p export NAMESPACE
mkdir -p "${NAMESPACE}"

ACME=${PLAN9}/bin/acme
GUIDE=${SCRIPT_DIR}/guide

# CGO_CFLAGS="-I/usr/local/include/"
# CGO_LDFLAGS="-L/usr/local/lib"

MANPATH=$PLAN9/man export MANPATH
# PATH=${PLAN9}/bin:$PATH
PATH=$PATH:${PLAN9}/bin
PATH=${SCRIPT_DIR}/cmd/:$PATH
export PATH

pgrep -f -x "9pserve -u unix\!${NAMESPACE}/plumb" || \
	plumber

pgrep -f -x acmefocused || \
	acmefocused &

cmd="rc ${SCRIPT_DIR}/auto.rc"
pgrep -f -x "${cmd}" || \
	$cmd &


if [ "${0##*/}" = "acmebright" ]; then
. ${SCRIPT_DIR}/solarized-bright.theme
fi

if [ "${0##*/}" = "acmedark" ]; then
. ${SCRIPT_DIR}/solarized-dark.theme
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

	SHELL=${PLAN9}/bin/rc $ACME -c 1 -a \
			-f ${PLAN9}/font/fixed/unicode.9x18.font \
			-t "$TEMPLATE" \
			"$@" $GUIDE
else
	SHELL=${PLAN9}/bin/rc $ACME -c 1 -a \
		-f ${PLAN9}/font/fixed/unicode.9x18.font \
		"$@" $GUIDE
fi
