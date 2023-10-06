#!/bin/bash 

set -e

source ${DEMO_MAGIC_PATH}/demo-magic.sh 

this_directory=$(dirname "$0")

start_demo

  wait # open in a browser
  app_guid=$(cf app --guid training-app )
  app_route=$(cf curl "/v3/apps/${app_guid}/routes" | jq -r '.resources[0].url')  

  pe "curl https://${app_route}/kill"

end_demo