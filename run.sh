#!/usr/bin/env bash
flex -l calculator.l
yacc -vd calculator.y
gcc -o calculator y.tab.c -ly -ll
./calculator