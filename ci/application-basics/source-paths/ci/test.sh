#!/bin/bash

set -e

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
repo_root="$(git rev-parse --show-toplevel)"
source "${repo_root}/ci/common-test/links.sh"
source "${repo_root}/ci/common-test/helpers.sh"

function cleanup {
  cf delete -f -r zip-with-src-path &> /dev/null
  cf delete -f -r zip-no-src-path &> /dev/null
  cf delete -f -r static-app &> /dev/null
  echo "Cleanup succeeded"
}
trap cleanup EXIT

cf_auth $CF_API $CF_ORG

cd ${script_dir}/../apps/zip-file
[[ $(cf target -o $CF_ORG -s development) ]] || { echo "Test failed: cf target -o $CF_ORG -s development" && exit 1; }
[[ $(cf push zip-with-src-path -p app.zip -b staticfile_buildpack -m 64M --random-route) ]] || { echo "Test failed: cf push" && exit 1; }
app_route=$(fetch_app_route zip-with-src-path 0)

[[ $(check_link $app_route; echo $?) = 0 ]] || { echo "Test failed: check_link $app_route" && exit 1; }

[[ $(cf push zip-no-src-path -b staticfile_buildpack -m 64M --random-route) ]] || { echo "Test failed: cf push" && exit 1; }
app_route=$(fetch_app_route zip-no-src-path 0)
[[ $(check_link $app_route; echo $?) != 0 ]] || { echo "Test failed: check_link $app_route" && exit 1; }
[[ $(cf rename zip-with-src-path static-app) ]] || { echo "Test failed: cf rename zip-with-src-path static-app" && exit 1; }