#!/bin/bash 

set -e

source ${DEMO_MAGIC_PATH}/demo-magic.sh 

this_directory=$(dirname "$0")

start_demo

  pe "cf get-health-check training-app"

  pe "cf set-health-check training-app http"

  pe "cf restart training-app"

  pe "cf get-health-check training-app"

end_demo