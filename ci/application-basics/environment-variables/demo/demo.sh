#!/bin/bash 

set -e

source ${DEMO_MAGIC_PATH}/demo-magic.sh 

this_directory=$(dirname "$0")

pushd $this_directory/../apps/training-app

  start_demo

  pe "cf push training-app -f manifest.yml -p training-app.zip --random-route"

  wait # open in a browser
  app_guid=$(cf app --guid training-app )
  app_route=$(cf curl "/v3/apps/${app_guid}/routes" | jq -r '.resources[0].url')
  open "https://${app_route}"

  pe "cf set-env training-app TRAINING_KEY_1 training-value-1"
  pe "cf set-env training-app TRAINING_KEY_2 training-value-2"
  pe "cf set-env training-app TRAINING_KEY_3 training-value-3"

  wait # open in a browser
  open "https://${app_route}"

  pe "cf restart training-app"

  wait # open in a browser
  open "https://${app_route}"

  pe "cf env training-app"

  pe "cf set-env training-app TRAINING_KEY_3 training-value-3_1"
  pe "cf restart training-app"

  # Add to manifest

  echo "  env:" >> manifest.yml
  echo "    TRAINING_KEY_1: training-value-1" >> manifest.yml
  echo "    TRAINING_KEY_2: training-value-2" >> manifest.yml
  echo "    TRAINING_KEY_3: training-value-3_1" >> manifest.yml

  pe "cat manifest.yml"

  pe "cf running-environment-variable-group"

  pe "cf staging-environment-variable-group"

  end_demo

popd