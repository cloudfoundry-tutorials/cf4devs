#!/bin/bash 

set -e

source ${DEMO_MAGIC_PATH}/demo-magic.sh 

this_directory=$(dirname "$0")

pushd ${this_directory}/../apps/multi-buildpack-app

  start_demo

    pe "cf buildpacks"

    pe "cf push multi-buildpack-app -b ruby_buildpack -b go_buildpack"

    pe "cf app multi-buildpack-app"

    wait # open in a browser
    app_guid=$(cf app --guid multi-buildpack-app )
    app_route=$(cf curl "/v3/apps/${app_guid}/routes" | jq -r '.resources[0].url')
    open "https://${app_route}"

    pe "cf delete -f -r multi-buildpack-app"

  end_demo

popd