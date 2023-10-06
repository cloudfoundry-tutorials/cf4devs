#!/bin/bash 

set -e

source ${DEMO_MAGIC_PATH}/demo-magic.sh 

this_directory=$(dirname "$0")

sk_guid=$(cf curl "/v3/service_credential_bindings?service_instance_names=training-app-db&names=psql-client" | jq -r '.resources[].guid')
sk_json=$(cf curl "/v3/service_credential_bindings/${sk_guid}/details")
sk_username=$(echo "$sk_json" | jq -r '.credentials.username')
sk_password=$(echo "$sk_json" | jq -r '.credentials.password')
sk_dbname=$(echo "$sk_json" | jq -r '.credentials.dbname')
sk_port=$(echo "$sk_json" | jq -r '.credentials.port')

start_demo

  echo "Copy this password: $sk_password"
  wait
  clear

  pe "psql -h localhost -p 6${sk_port} -U ${sk_username} -W -d ${sk_dbname}"

end_demo
