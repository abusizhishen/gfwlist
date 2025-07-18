#!/bin/sh

if [ -z "$1" ]; then
    echo "no commit message"
    exit
fi

echo "commit $1"
git add .
git commit -m "$1"
git push