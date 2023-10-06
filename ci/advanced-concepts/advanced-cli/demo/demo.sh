#!/bin/bash 

set -e

source ${DEMO_MAGIC_PATH}/demo-magic.sh 

this_directory=$(dirname "$0")

start_demo

  open "https://v3-apidocs.cloudfoundry.org/version/3.101.0/index.html#list-apps"

  pe "cf curl /v3/apps"

  pe "cf curl /v3/apps | jq -r '.resources[].name'"
  
end_demo