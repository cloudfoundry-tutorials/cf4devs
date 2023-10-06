#!/bin/bash 

set -e

source ${DEMO_MAGIC_PATH}/demo-magic.sh 

this_directory=$(dirname "$0")

start_demo

  app_guid=$(cf app training-app --guid)
  route=$(cf curl "/v3/apps/${app_guid}/env" | jq -r ".application_env_json.VCAP_APPLICATION.uris[0]")
  hostname=$(echo $route | sed "s/.${CF_APP_DOMAIN}//g")

  pe "cf map-route training-app apps.internal --hostname $hostname"
  pe "cf unmap-route training-app $CF_APP_DOMAIN --hostname $hostname"
  pe "cf app training-app"

  pe "cf push -f ${this_directory}/../../../../applications/proxy/manifest.yml -p ${this_directory}/../../../../applications/proxy --var route=${hostname}.${CF_APP_DOMAIN} --var proxied_route=${hostname}.apps.internal --var proxied_port=8080"
  pe "cf a"
  wait # open in a browser
  open "https://${hostname}.${CF_APP_DOMAIN}"

  pe "cf add-network-policy nginx-proxy training-app --port 8080 --protocol tcp"
  wait
  open "https://${hostname}.${CF_APP_DOMAIN}"

  pe "cf remove-network-policy nginx-proxy training-app --port 8080 --protocol tcp"

end_demo