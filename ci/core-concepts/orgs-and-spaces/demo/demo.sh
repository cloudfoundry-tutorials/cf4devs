#!/bin/bash 

set -e

source ${DEMO_MAGIC_PATH}/demo-magic.sh 

start_demo

pe "cf t"

pe "cf orgs"

pe "cf spaces"

pe "cf t -o $CF_ORG -s $CF_SPACE"

pe "cf app first-push"

end_demo