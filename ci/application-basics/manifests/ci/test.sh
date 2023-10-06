#!/bin/bash

set -e

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
repo_root="$(git rev-parse --show-toplevel)"
source "${repo_root}/ci/common-test/links.sh"
source "${repo_root}/ci/common-test/helpers.sh"

function cleanup {
  cf delete -f -r static-app 1> /dev/null
  echo "Cleanup succeeded"
}
trap cleanup EXIT

cf_auth $CF_API $CF_ORG

cd ${script_dir}/../apps/static-app
[[ $(cf target -o $CF_ORG -s development) ]] || { echo "Test failed: cf target -o $CF_ORG -s development" && exit 1; }
[[ $(cf push static-app --random-route -p app.zip) ]] || { echo "Test failed: cf push" && exit 1; }
[[ $(cf create-app-manifest static-app) ]] || { echo "Test failed: cf create-app-manifest" && exit 1; }
[[ -f static-app_manifest.yml ]] || { echo "Test failed: static-app_manifest.yml not found" && exit 1; }
[[ $(cf delete -f -r static-app) ]] || { echo "Test failed: cf delete" && exit 1; }
[[ $(cf push -f static-app_manifest.yml -b staticfile_buildpack) ]] || { echo "Test failed: cf push -f static-app_manifest.yml" && exit 1; }
[[ $(cf delete --help) ]] || { echo "Test failed: cf delete --help" && exit 1; }
app_route=$(fetch_app_route static-app 0)
[[ $(check_link $app_route; echo $?) != 0 ]] || { echo "Test failed: check_link $app_route" && exit 1; }
[[ $(cf push -f static-app_manifest.yml -p app.zip) ]] || { echo "Test failed: cf push -f static-app_manifest.yml -p app.zip" && exit 1; }
[[ $(check_link $app_route; echo $?) = 0 ]] || { echo "Test failed: check_link $app_route" && exit 1; }
[[ $(cf push -f static-app_manifest.yml -p app.zip -k 128M) ]] || { echo "Test failed: cf push -f static-app_manifest.yml -p app.zip -k 128M" && exit 1; }
[[ $(cf app static-app | grep 128M) ]] || { echo "Test failed: cf app static-app | grep 128M" && exit 1; }