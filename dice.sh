#!/bin/bash
# this script rolls dice and show what was rolled, as well as the sum of the dice rolled
# the user can specify how many sides each die should have using a commnad line option

#defaults
sides=6
numdice=2

# functions
displayhelp () {
	cat <<EOF
$(basename $0) [-h] [-s N]
-h display help and exit
-s N specify number of sides for dice, N is a number from 2 to 20, default is 6
EOF
}

# command line processing
while [ $# -gt 0 ]; do
case "$1" in
-h )
displayhelp
exit
;;
-s )
shift
sides=$1
if [ -n "$sides" ]; then
if [ $sides -lt 2 -o $sides -gt 20 ]; then
displayhelp
exit 1
fi
else
displayhelp
exit 1
fi
;;
* )
echo "Invalid input: '$1'"
exit 1
;;
esac
shift
done

# main script functionality - rolling the dice!
total=0
printf "Rolling... "
for (( numrolled=0; numrolled < $numdice ; numrolled++ )); do
	roll=$(( RANDOM % sides + 1 ))
	printf "$roll "
	total=$(( roll + total ))
done
printf "\n Rolled a $total\n"
