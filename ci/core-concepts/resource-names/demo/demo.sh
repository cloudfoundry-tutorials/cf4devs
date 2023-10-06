#!/bin/bash 

set -e

source ${DEMO_MAGIC_PATH}/demo-magic.sh 

start_demo

pe "cf apps"

pe "cf app first-push --guid"

pe "cf rename first-push renamed-app"

pe "cf app renamed-app --guid"

pe "cf delete -r renamed-app"

end_demo
