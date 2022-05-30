#!/bin/sh
#
for f in `find . -name \*.md`
do
  cat tooling/layout_header-default.txt $f > $f.new
  mv $f.new $f
done
