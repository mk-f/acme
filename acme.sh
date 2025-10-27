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

DEBUG=0
VALGRIND=
while getopts :dv opt; do
	case $opt in
	d)	DEBUG=1;;
	v)	VALGRIND="valgrind --leak-check=full";;
	?)	usage;;
	esac
done

shift $(($OPTIND - 1))

command -v 9 && RUN9=9 || RUN9="${HOME}/src/plan9port/bin/9"

PLAN9="${PLAN9:-${HOME}/src/plan9port}"
export PLAN9

PATH="${SCRIPT_DIR}/cmd:${PATH}"
export PATH

AUTO_RC="rc ${SCRIPT_DIR}/auto.rc"

# Namespace superseeds DISPLAY
if [ $DEBUG -eq 1 ]; then
	NAMESPACE=/tmp/ns.acme.DEBUG.p9p
else
	NAMESPACE=/tmp/ns.acme.p9p
fi

export NAMESPACE
mkdir -p "${NAMESPACE}"

GUIDE=${SCRIPT_DIR}/guide

if [ $DEBUG -eq 1 ]; then
	echo DEBUG >> /tmp/acme.debug
	#valgrind --leak-check=full
	${VALGRIND:+${VALGRIND}} "${PLAN9}/src/cmd/acme/o.acme" -c 1 -a \
		-f ${PLAN9}/font/fixed/unicode.9x18.font \
		"$@" /tmp/acme.debug &
	while ! 9p ls acme >/dev/null 2>&1; do sleep 1; done
	printf '%s\n' '' '|a+' '|a-' Edit Win Src | 9p write acme/1/wrmenu
else
	pgrep -f -x "9pserve -u unix\!${NAMESPACE}/plumb" || \
		${RUN9} plumber

	pgrep -f -x acmefocused || \
		acmefocused &

	pgrep -f -x "${AUTO_RC}" || \
		${RUN9} $AUTO_RC &

	${RUN9} acme -c 1 -a \
		-f ${PLAN9}/font/fixed/unicode.9x18.font \
		"$@" $GUIDE
fi
