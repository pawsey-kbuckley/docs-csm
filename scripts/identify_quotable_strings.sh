#!/bin/sh
#
for f in `find . -name \*.md`
do
  grep -n -H "{%" $f
done
true
