#!/bin/bash 

set -e

source ${DEMO_MAGIC_PATH}/demo-magic.sh 

this_directory=$(dirname "$0")

start_demo

  domain="my-domain.example.com"

  pe "cf domains"
  pe "cf create-private-domain $CF_ORG $domain "
  pe "cf map-route training-app $domain --hostname training"
  pe "cf delete-private-domain $domain"

end_demo