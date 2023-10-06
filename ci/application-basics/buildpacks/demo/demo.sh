#!/bin/bash 

set -e

source ${DEMO_MAGIC_PATH}/demo-magic.sh 

this_directory=$(dirname "$0")

pushd $this_directory/../../manifests/apps/static-app

  start_demo

    pe "cf buildpacks"

    pe "cf push -b https://github.com/cloudfoundry/staticfile-buildpack.git#v1.5.21 -f static-app_manifest.yml --var instances=1 -p app.zip"    
    
  end_demo

popd