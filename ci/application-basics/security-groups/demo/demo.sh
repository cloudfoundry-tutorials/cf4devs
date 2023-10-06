#!/bin/bash 

set -e

source ${DEMO_MAGIC_PATH}/demo-magic.sh 

this_directory=$(dirname "$0")

start_demo

  pe "cf staging-security-groups"
  pe "cf running-security-groups"
  pe "cf security-group dns"

end_demo
