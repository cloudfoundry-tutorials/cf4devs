#!/bin/bash

set -e

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
repo_root="$(git rev-parse --show-toplevel)"
source "${repo_root}/ci/common-test/links.sh"
source "${repo_root}/ci/common-test/helpers.sh"

function cleanup {
  cf delete -f -r large-app &> /dev/null
  echo "Cleanup succeeded"
}
trap cleanup EXIT

cf_auth $CF_API $CF_ORG

cd ${script_dir}/../apps/large-app
[[ $(cf target -o $CF_ORG -s development) ]] || { echo "Test failed: cf target -o $CF_ORG -s development" && exit 1; }
[[ $(cf org $CF_ORG) ]] || { echo "Test failed: cf org $CF_ORG" && exit 1; }
org_quota_name=$(cf org $CF_ORG | grep quota: | awk '{print $2}')
[[ $(cf org-quota $org_quota_name | grep "total memory") ]] || { echo "Test failed: cf org-quota $org_quota_name" && exit 1; }
[[ $(cf space development) ]] || { echo "Test failed: cf space development" && exit 1; }
space_quota_name=$(cf space development | grep quota: | awk '{print $2}')
[[ $(cf space-quota $space_quota_name) ]] || { echo "Test failed: cf space-quota $space_quota_name" && exit 1; }
[[ $(cf target -s small) ]] || { echo "Test failed: cf target -s small" && exit 1; }
[[ $(cf push large-app --random-route -p app.zip; echo $?) != 0 ]] || { echo "Test failed: cf push" && exit 1; }
[[ $(cf push large-app --random-route -p app.zip -f ${script_dir}/updated_manifest.yml) ]] || { echo "Test failed: cf push" && exit 1; }


