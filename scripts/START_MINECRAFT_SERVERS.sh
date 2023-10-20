#! /bin/bash

cd "$(dirname "$0")"

cd ../minecraft/servers

for server in $(ls | grep -v shared); do
    cd $server
    make start
    cd ..
done