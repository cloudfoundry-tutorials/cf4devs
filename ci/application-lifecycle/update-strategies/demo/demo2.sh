#!/bin/bash 

set -e

source ${DEMO_MAGIC_PATH}/demo-magic.sh 

this_directory=$(dirname "$0")

start_demo

  wait
  app_guid=$(cf app updating-app --guid)
  route=$(cf curl "/v3/apps/${app_guid}/env" | jq -r ".application_env_json.VCAP_APPLICATION.uris[0]")
  hostname=$(echo $route | sed "s/.${CF_APP_DOMAIN}//g")
  
  pe "watch -n 0.5 curl -L https://${route}"

end_demo
