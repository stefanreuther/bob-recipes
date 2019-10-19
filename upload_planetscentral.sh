#!/bin/sh
#
#  Upload PlanetsCentral binaries
#
#  Host:
#     bob build release::planetscentral-bin
#     upload_planetscentral.sh
#  Target:
#     rsync -vrlptS relay/opt/ /opt/
#     <restart as needed>
#

p=$(bob query-path --release release::planetscentral-bin -f {dist})
if test -z "$p"; then
  echo "Unable to find release; do 'bob build release::planetscentral-bin'"
  exit 1
fi

rsync -vrlptS --delete "$p/" pcc:relay/
