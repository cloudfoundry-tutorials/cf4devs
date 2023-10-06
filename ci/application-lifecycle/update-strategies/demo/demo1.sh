#!/bin/bash 

set -e

source ${DEMO_MAGIC_PATH}/demo-magic.sh 

this_directory=$(dirname "$0")

pushd ${this_directory}/../apps/updating-app

  cf push

  echo "Start the other two demo scripts in other windows once the app starts"
  wait

  start_demo
    
    echo "GREEN" > index.html
    echo " " 
    pe "cat index.html"
    echo " " 

    pe "cf push --strategy rolling"


    echo "RED" > index.html
    echo " " 
    pe "cat index.html"
    echo " " 

    pe "cf push --strategy rolling --no-wait"

    pe "cf cancel-deployment updating-app"

    pe "cf delete -f -r updating-app"


    echo "BLUE" > index.html

  end_demo

popd