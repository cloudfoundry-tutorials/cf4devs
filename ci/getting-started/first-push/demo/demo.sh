#!/bin/bash

set -e

source ${DEMO_MAGIC_PATH}/demo-magic.sh 

this_directory=$(dirname "$0")
pushd $this_directory/../../../../applications/first-push

  start_demo

  # Don't forget to log back in
  pe "cf target"

  pe "pwd"

  pe "ls"

  pe "cat manifest.yml"

  pe "cf push"

  wait # open in a browser
  app_guid=$(cf app --guid first-push)
  app_route=$(cf curl "/v3/apps/${app_guid}/routes" | jq -r '.resources[0].url')
  open "https://${app_route}"

popd