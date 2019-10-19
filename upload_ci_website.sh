#!/bin/sh
#
#  Upload Website CI build
#
#  Host:
#     bob dev --sandbox ci::noarch/planets::website-daily-dat       # usually done via CI
#     upload_ci_website.sh
#

p=$(bob query-path --sandbox ci::noarch/planets::website-daily-dat -f {dist})
if test -z "$p"; then
  echo "Unable to find CI result"
  exit 1
fi

rsync -vrlptS --delete "$p/" pcc:public_html/test/
