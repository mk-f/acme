#!/bin/sh
set -eu

SCRIPT_DIR=$(dirname "$(readlink -f $0)")

trap 'set +e; _cleanup; trap - EXIT; exit' \
	EXIT INT HUP TERM

_cleanup() {
	pkill -x -f "${AUTO_RC}"
	pkill acmefocused
	pkill plumber;
}

command -v 9 && RUN9=9 || RUN9="${HOME}/src/plan9port/bin/9"

PLAN9="${PLAN9:-${HOME}/src/plan9port}"
export PLAN9

PATH="${SCRIPT_DIR}/cmd:${PATH}"
export PATH

AUTO_RC="rc ${SCRIPT_DIR}/auto.rc"

# Namespace superseeds DISPLAY
NAMESPACE=/tmp/ns.acme.p9p export NAMESPACE
mkdir -p "${NAMESPACE}"

GUIDE=${SCRIPT_DIR}/guide

pgrep -f -x "9pserve -u unix\!${NAMESPACE}/plumb" || \
	${RUN9} plumber

pgrep -f -x acmefocused || \
	acmefocused &

pgrep -f -x "${AUTO_RC}" || \
	${RUN9} $AUTO_RC &

#SHELL='/usr/bin/rc' ${RUN9} acme -c 1 -a \
${RUN9} acme -c 1 -a \
	-f ${PLAN9}/font/fixed/unicode.9x18.font \
	"$@" $GUIDE
