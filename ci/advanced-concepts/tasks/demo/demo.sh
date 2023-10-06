#!/bin/bash 

set -e

source ${DEMO_MAGIC_PATH}/demo-magic.sh 

this_directory=$(dirname "$0")

start_demo

  pe "cf run-task training-app -m 8M -k 64M --name sample-task --command tasks/sample-task.sh"

  pe "cf tasks training-app"

  pe "cf logs --recent training-app"

end_demo