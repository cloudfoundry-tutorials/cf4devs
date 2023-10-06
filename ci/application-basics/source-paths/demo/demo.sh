#!/bin/bash 

set -e

source ${DEMO_MAGIC_PATH}/demo-magic.sh 

this_directory=$(dirname "$0")
pushd $this_directory/../apps/zip-file

start_demo

  pe "pwd"

  pe "ls"

  pe "cf push zip-with-src-path -p app.zip -b staticfile_buildpack -m 32M -k 64M --random-route"

  wait # open in a browser
  app_guid=$(cf app --guid zip-with-src-path )
  app_route=$(cf curl "/v3/apps/${app_guid}/routes" | jq -r '.resources[0].url')
  open "https://${app_route}"

  pe "cf push zip-no-src-path -b staticfile_buildpack -m 32M -k 64M --random-route"

  wait # open in a browser
  app_guid=$(cf app --guid zip-no-src-path )
  app_route=$(cf curl "/v3/apps/${app_guid}/routes" | jq -r '.resources[0].url')
  open "https://${app_route}"


  wait
  open "https://${app_route}/app.zip"

  pe "cf delete -r -f zip-no-src-path"

  pe "cf rename zip-with-src-path static-app"

end_demo
