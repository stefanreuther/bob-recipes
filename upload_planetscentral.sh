#!/bin/sh

p=$(bob query-path --release release::planetscentral-bin -f {dist})
if test -z "$p"; then
  echo "Unable to find release; do 'bob build release::planetscentral-bin'"
  exit 1
fi

rsync -vrlptS --delete "$p/" pcc:relay/
