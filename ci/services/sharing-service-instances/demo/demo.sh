#!/bin/bash 

set -e

source ${DEMO_MAGIC_PATH}/demo-magic.sh 

this_directory=$(dirname "$0")

start_demo

  # pe "cf curl /v3/service_offerings"
  pe "cf share-service training-app-db -s services"
  pe "cf service training-app-db"

  pe "cf target -s services"
  pe "cf service training-app-db"

  pe "cf target -s dev"
  pe "cf unshare-service training-app-db -s services"
  pe "cf service training-app-db"

end_demo