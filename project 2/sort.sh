#!/usr/bin/env bash

header=$(awk 'BEGIN{FS="\t"; OFS="\t"} NR==1 {print "key",$0}' "$1")
data=$(awk 'BEGIN{FS="\t"; OFS="\t"} NR>1 {print $1 $2 $3,$0}' "$1" | sort)

echo "$header"
echo "$data"

rm $1