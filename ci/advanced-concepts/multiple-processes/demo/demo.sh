#!/bin/bash 

set -e

source ${DEMO_MAGIC_PATH}/demo-magic.sh 

this_directory=$(dirname "$0")

pushd ${this_directory}/../../../../applications/multi-process

  start_demo

    pe "cat manifest.yml"

    pe "cf push --random-route"
    pe "cf app multi-process"

    pe "cf scale multi-process --process web -i 2"

    pe "cf scale multi-process --process worker -i 3"

    pe "cf ssh multi-process --process web"

    pe "cf delete -f -r multi-process"

  end_demo

popd