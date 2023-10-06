#!/bin/bash 

set -e

source ${DEMO_MAGIC_PATH}/demo-magic.sh 

start_demo

pe "cf version"

pe "cf help"

pe "cf help -a"

pe "cf login --help"

pe "cf help" # look for marketplace shortcut

pe "cf config --locale de-DE"

pe "cf help"

pe "cf config --locale CLEAR"

end_demo