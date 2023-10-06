#!/bin/bash 

set -e

source ${DEMO_MAGIC_PATH}/demo-magic.sh 

this_directory=$(dirname "$0")

start_demo

  pe "cf restart training-app"


  pe "cf ssh training-app -i 0"
  # rm -fr app
  # exit
  pe "cf restart-app-instance training-app 0"


  pe "cf restage training-app"

end_demo
