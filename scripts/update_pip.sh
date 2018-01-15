#!/bin/bash

FROZEN=`pip3 freeze`
FROZEN="${FROZEN//==/>=}"
echo "$FROZEN" > tmp_pip.txt
sed -i '/pygobject/d' ./tmp_pip.txt
sed -i '/texttable/d' ./tmp_pip.txt
sed -i '/awscli/d' ./tmp_pip.txt
pip3 install -Ur tmp_pip.txt
rm tmp_pip.txt
