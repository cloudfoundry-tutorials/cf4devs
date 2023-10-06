#!/bin/bash 

set -e

source ${DEMO_MAGIC_PATH}/demo-magic.sh 

this_directory=$(dirname "$0")

start_demo

  pe "cf cups non-interactive -p '{\"user\":\"some-user\", \"password\":\"some-password\", \"url\":\"some-url\"}'"
  pe "cf cups interactive -p 'user, password, url'"
  pe "cf bind-service training-app non-interactive"
  pe "cf bind-service training-app interactive"
  pe "cf env training-app"
  pe "cf restart training-app"

  wait
  app_guid=$(cf app --guid training-app )
  app_route=$(cf curl "/v3/apps/${app_guid}/routes" | jq -r '.resources[0].url')
  open "https://${app_route}"

  pe "cf uups interactive -p 'user, password, url'"
  pe "cf env training-app"
  pe "cf restart training-app"
  pe "cf cups --help"

end_demo