#!/bin/sh
#
#  Upload Website Release build
#
#  Host:
#     bob build release::website-<date>
#     upload_release_website.sh <date>
#

if test -z "$1"; then
  echo "Please pass a release date as parameter"
  exit 1
fi

p=$(bob query-path --release --sandbox "release::website-$1" -f {dist})
if test -z "$p"; then
  echo "Unable to find CI result"
  exit 1
fi

rsync -vrlptS --delete "$p/" pcc:public_html/test/
