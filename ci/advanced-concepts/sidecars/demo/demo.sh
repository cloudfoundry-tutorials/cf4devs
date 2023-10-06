#!/bin/bash 

set -e

source ${DEMO_MAGIC_PATH}/demo-magic.sh 

this_directory=$(dirname "$0")

pushd ${this_directory}/../../../../applications/sidecar-dependent-app

  start_demo

    pe "cat manifest.yml"

    pe "cf push --random-route"

    pe "cf ssh sidecar-dependent-app" 
    #ps aux

    wait # open in a browser
    app_guid=$(cf app --guid sidecar-dependent-app )
    app_route=$(cf curl "/v3/apps/${app_guid}/routes" | jq -r '.resources[0].url')
    open "https://${app_route}/config"    

  end_demo

popd