#!/bin/bash 

set -e

source ${DEMO_MAGIC_PATH}/demo-magic.sh 

this_directory=$(dirname "$0")

start_demo

  pe "cf ssh-enabled training-app"

  pe "cf enable-ssh training-app"

  pe "cf space-ssh-allowed dev"

  pe "cf allow-space-ssh dev"

  pe "cf restart training-app --strategy rolling"

  pe "cf ssh training-app -i 0"
  
  # View the files in the container. The `app` directory contains your application code as processed/assembled by the buildpack. 
  # Verify runtimes and dependencies used by your application.
  # Test connectivity to external dependencies like service instances or other apps.

  pe "cf restart-app-instance training-app 0"

end_demo