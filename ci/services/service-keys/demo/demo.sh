#!/bin/bash 

set -e

source ${DEMO_MAGIC_PATH}/demo-magic.sh 

this_directory=$(dirname "$0")

start_demo

  pe "cf create-service-key training-app-db psql-client"
  pe "cf service-key training-app-db psql-client"

  sk_guid=$(cf curl "/v3/service_credential_bindings?service_instance_names=training-app-db&names=psql-client" | jq -r '.resources[].guid')
  sk_json=$(cf curl "/v3/service_credential_bindings/${sk_guid}/details")
  sk_hostname=$(echo "$sk_json" | jq -r '.credentials.hostname')
  sk_port=$(echo "$sk_json" | jq -r '.credentials.port')

  pe "cf ssh -L 6${sk_port}:${sk_hostname}:${sk_port} training-app -i 0"
  cmd # be able to ctrl-c to exit
  pe "cf restart-app-instance training-app 0"

  pe "cf delete-service-key training-app-db psql-client"

end_demo
