#!/bin/bash

source=../source
output=./output

rm -rf $output
mkdir -p $output
cp -r $source/* $output/

for file in `find . -type f -name '*.coffee'`
do
    coffee -c $file > /dev/null 2>&1
    echo $file | sed 's|coffee$|js|' | xargs uglifyjs --overwrite
done

find . -type f -name *.less | sed 's/less$//' | awk '{print "lessc " $1 "less " $1 "css" }' | sh

if [[ "$1" = build ]]; then
    exit 0
fi

clear

cd $output
node app.js
cd ..
