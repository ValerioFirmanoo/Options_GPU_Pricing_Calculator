#!/bin/bash

for i in {1..999}
do 
  sleep 1
  ./executable 
  #mv path_exact.dat data/path_exact.$i.dat
  #mv path_euler.dat data/path_euler.$i.dat
  cat call_opt.dat >> data/call_option.dat
  echo code executed $i times
done
