#!/bin/bash 

set -e

source ${DEMO_MAGIC_PATH}/demo-magic.sh 

this_directory=$(dirname "$0")
pushd $this_directory/../apps/static-app

start_demo

  pe "cf apps"

  pe "cf create-app-manifest static-app"

  pe "ls"

  pe "cat static-app_manifest.yml"

  pe "cf delete -f -r static-app"
  
  pe "cf push -f static-app_manifest.yml"


  wait # open in a browser
  app_guid=$(cf app --guid static-app )
  app_route=$(cf curl "/v3/apps/${app_guid}/routes" | jq -r '.resources[0].url')
  open "https://${app_route}"

  pe "cat static-app_manifest.yml"

  pe "cf push -f static-app_manifest.yml -p app.zip"


  pe "cf push -f static-app_manifest.yml -p app.zip -k 128M"


  # Variables
  sed -i '' "s/instances: 1/instances: ((instances))/g" static-app_manifest.yml
  pe "cat static-app_manifest.yml"
  pe "cf push -f static-app_manifest.yml -p app.zip --var instances=1"

  # Variable file
  echo "instances: 1" > static-app_dev.yml
  pe "cat static-app_dev.yml"
  pe "cf push -f static-app_manifest.yml -p app.zip --vars-file=static-app_dev.yml"

end_demo

popd