#!/bin/sh
#
#  Upload PlanetsCentral binaries
#
#  Host:
#     bob build release::planetscentral-pkg
#     upload_planetscentral_pkg.sh
#  Target:
#     dpkg -i ...
#

p=$(bob query-path --release release::planetscentral-pkg -f {dist})
if test -z "$p"; then
  echo "Unable to find release; do 'bob build release::planetscentral-pkg'"
  exit 1
fi

scp "$p/"*.deb pcc:
