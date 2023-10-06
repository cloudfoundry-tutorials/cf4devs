 #!/bin/bash 

source ${DEMO_MAGIC_PATH}/demo-magic.sh 

this_directory=$(dirname "$0")

start_demo 
  
  pe "cf revisions training-app"
  pe "cf env training-app"
  pe "cf rollback training-app --version 1"
  pe "cf env training-app"

  app_guid=$(cf app training-app --guid)
  pe "cf app training-app --guid"
  pe "cf curl /v3/apps/${app_guid}/features/revisions -X PATCH -d '{ \"enabled\": false }'"
  pe "cf revisions training-app"
  pe "cf rollback training-app --version 2"
  pe "cf curl /v3/apps/${app_guid}/features/revisions -X PATCH -d '{ \"enabled\": true }'"

end_demo