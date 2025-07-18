#!/bin/bash

declare -a stuffToProcess
while [ $# -gt 0 ]; do
	case "$1" in
	-h | --help )
		echo "Usage: $0 [-h] [stuff ...]"
		exit 0
		;;
	* )
		stuffToProcess+=("$1")
		;;
	esac
	shift
done
[ ${#stuffToProcess[@]} ] && echo "Will do work on ${stuffToProcess[@]} (${#stuffToProcess[@]} items)"
