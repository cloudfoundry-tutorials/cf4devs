#!/bin/bash 

set -e

source ${DEMO_MAGIC_PATH}/demo-magic.sh 

this_directory=$(dirname "$0")

start_demo

  pe "cf logs training-app"
  pe "cf logs training-app --recent"
  pe "cf events training-app"

end_demo
