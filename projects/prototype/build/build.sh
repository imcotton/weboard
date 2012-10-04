#!/bin/bash

source=../source
output=./output

mkdir -p $output
cp -r $source/* $output/

find . -type f -name *.coffee | xargs coffee -c
find . -type f -name *.less | sed 's/less$//' | awk '{print "lessc " $1 "less " $1 "css" }' | sh

if [[ "$1" = build ]]; then
    exit 0
fi

clear

cd $output
node app.js
cd ..
