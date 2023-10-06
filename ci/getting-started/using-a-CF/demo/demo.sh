#!/bin/bash

set -e

source ${DEMO_MAGIC_PATH}/demo-magic.sh 

start_demo

pe "cf api $API_ENDPOINT"

pe "cf api"

pe "cf login --help"

pe "cf login" # interactive login

pe "cf login --sso" # interactive browser login

pe "cf target"

pe "cf logout"

pe "cf target"

end_demo