#!/bin/bash

source=../source
output=./output

mkdir -p $output
cp -r $source/* $output/

find -type f -name *.coffee | xargs coffee -c

#exit 0

clear

cd $output
node app.js
cd ..
