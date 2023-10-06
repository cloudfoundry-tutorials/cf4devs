#!/bin/bash 

set -e

source ${DEMO_MAGIC_PATH}/demo-magic.sh 

this_directory=$(dirname "$0")

start_demo

  pe "cf m"

  pe "cf m | grep $CF_SERVICE_GREP"

  pe "cf m -e $CF_SERVICE_NAME"

  pe "cf create-service $CF_SERVICE_NAME $CF_SERVICE_PLAN training-app-db"

  pe "cf services"

  pe "cf services"

  pe "cf bind-service training-app training-app-db"

  pe "cf env training-app"

  wait
  app_guid=$(cf app --guid training-app )
  app_route=$(cf curl "/v3/apps/${app_guid}/routes" | jq -r '.resources[0].url')
  open "https://${app_route}"

  pe "cf restart training-app"

  wait # open in a browser
  open "https://${app_route}"

  pe "cf unbind-service training-app training-app-db"

  pe "cf env training-app"

  wait # open in a browser
  open "https://${app_route}"

  pe "cf restart training-app"

  wait # open in a browser
  open "https://${app_route}"

  pe "cf delete-service training-app-db"

end_demo
