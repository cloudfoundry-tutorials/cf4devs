#!/bin/bash 

set -e

source ${DEMO_MAGIC_PATH}/demo-magic.sh 

this_directory=$(dirname "$0")

start_demo

  pe "cf scale -i 2 training-app"
  pe "cf scale -m 48M -k 256M training-app"
  pe "cf app training-app"

end_demo
