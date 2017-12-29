#!/usr/bin/bash

FROZEN=`pip freeze`
FROZEN="${FROZEN//==/>=}"
echo "$FROZEN" > tmp_pip.txt
sed -i '/pygobject/d' ./tmp_pip.txt
pip install -Ur tmp_pip.txt
rm tmp_pip.txt
