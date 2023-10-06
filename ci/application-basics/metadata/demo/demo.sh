#!/bin/bash 

set -e

source ${DEMO_MAGIC_PATH}/demo-magic.sh 

this_directory=$(dirname "$0")

start_demo

  pe "cf set-label app training-app env=dev"
  pe "cf labels app training-app"
  pe "cf apps --labels 'env=dev'"
  pe "cf set-label app training-app sensitive=true"
  pe "cf apps --labels 'env=dev,sensitive=true'"
  wait
  cat $this_directory/manifest.yml

  echo " "

end_demo
