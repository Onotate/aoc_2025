#!/usr/bin/env bash

# Since parsing the operators first create less headache, we're gonna cheat a bit
# Move the last line to top
tail -n 2 "$1" | head -n 1 ; head -n -2 $1 ; echo ""

