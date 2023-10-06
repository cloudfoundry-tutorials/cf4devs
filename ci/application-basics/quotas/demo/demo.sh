#!/bin/bash 

set -e

source ${DEMO_MAGIC_PATH}/demo-magic.sh 

this_directory=$(dirname "$0")

start_demo

  pe "cf org $CF_ORG"
  quota_guid=$(cf curl "/v3/organizations?names=$CF_ORG" | jq -r '.resources[].relationships.quota.data.guid')
  quota_name=$(cf curl "/v3/organization_quotas/$quota_guid" | jq -r '.name')
  pe "cf org-quota $quota_name"

  pe "cf space $CF_SPACE"

end_demo
