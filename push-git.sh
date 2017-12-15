#!/bin/sh

if [ $# -lt 1 ]
  then
    echo "Usage:"
    echo "./git-push.sh <commit_message>"
    exit
fi

message=$1

git add *
git commit -m $1
git push

