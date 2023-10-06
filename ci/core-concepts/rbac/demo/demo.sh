#!/bin/bash 

set -e

source ${DEMO_MAGIC_PATH}/demo-magic.sh 

start_demo

pe "cf org-users $CF_ORG"

pe "cf set-org-role --help"

pe "cf unset-org-role --help"

pe "cf space-users $CF_ORG $CF_SPACE"

pe "cf set-space-role --help"

pe "cf unset-space-role --help"

pe "cf org-users $CF_ORG -a"

end_demo