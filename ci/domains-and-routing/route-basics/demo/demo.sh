#!/bin/bash 

set -e

source ${DEMO_MAGIC_PATH}/demo-magic.sh 

this_directory=$(dirname "$0")

start_demo

  hostname="cff-training-app"
  
  app_guid=$(cf app training-app --guid)
  route=$(cf curl "/v3/apps/${app_guid}/env" | jq -r ".application_env_json.VCAP_APPLICATION.uris[0]")
  old_hostname=$(echo $route | sed "s/.${CF_APP_DOMAIN}//g")

  pe "cf routes"

  pe "cf create-route $CF_APP_DOMAIN --hostname $hostname"

  pe "cf map-route training-app $CF_APP_DOMAIN --hostname $hostname"

  pe "cf app training-app"

  pe "cf unmap-route training-app $CF_APP_DOMAIN --hostname $old_hostname"

  pe "cf app training-app"

  pe "cf routes"

  pe "cf delete-route $CF_APP_DOMAIN --hostname $old_hostname"

end_demo
