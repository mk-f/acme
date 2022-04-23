#!/bin/sh
DEBUG=1
msg() {
	if [ $DEBUG -eq 1 ]; then
		printf '%s\n' "$1" | 9p write acme/cons
	fi
}

hashbang() {
	printf '%s' '0,1' | 9p write acme/${1}/addr
	9p read acme/${1}/xdata
}

is_extension() {
	ext="${1##*.}"
	if [ "$ext" = "${2}" ]; then
		return 0
	else
		return 1
	fi
}

is_python() {
	if is_extension "${2}" 'py'; then
		msg 'detected python by extension'
		return 0
	fi
	if echo $(hashbang "${1}") | grep -q '^#!.*python.*'; then
		msg 'detected python by hashbang'
		return 0
	fi

	return 1
}

is_markdown() {
	if is_extension "${1}" 'md'; then
		msg 'detected markdown by extension'
		return 0
	fi

	return 1
}

indent_spaces() {
	if printf spacesindent | 9p write acme/$1/ctl; then
		printf 'tabstop %s\n' "$2" | 9p write acme/$1/ctl
		msg "spaceindent on, tabstop $2"
	else
		msg "spaces-patch missing"
	fi
}

9p read acme/log | while read -r line; do
	# id, event, file
	set -- $line

	# just interested in 'new' events
	[ "$2" != "new" ] && continue

	if is_python "$1" "$3" || is_markdown "$3"; then
		indent_spaces $1 2
	fi
done
