#!/bin/bash

while read line
do
  for (( i=0; i<${#line}; i++ ))
  do
    echo -n "${line:$i:1}"
    sleep 0.05
  done
  echo
done < atm_manual.txt
