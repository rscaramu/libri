#!/bin/sh
n=${1:-10}
a=0; b=1; i=0
while [ $i -lt $n ]; do
  echo $a
  t=$((a+b)); a=$b; b=$t
  i=$((i+1))
done
