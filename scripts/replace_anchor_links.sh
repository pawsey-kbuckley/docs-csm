#!/bin/sh
#
while egrep -q "](.*)\.md#" $1
do
  sed -i -e "s/\(](.*\)\.md#/\1\.html#/" $1
done
