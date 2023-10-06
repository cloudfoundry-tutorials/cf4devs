#!/bin/bash

set -e

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
repo_root="$(git rev-parse --show-toplevel)"
source "${repo_root}/ci/common-test/links.sh"
source "${repo_root}/ci/common-test/helpers.sh"

function cleanup {
  cf delete -f -r first-push 1> /dev/null
  echo "Cleanup succeeded"
}
trap cleanup EXIT

cf_auth $CF_API $CF_ORG

cd ${script_dir}/../apps/first-push
[[ $(cf target -s development) ]] || { echo "Test failed: cf target -s development" && exit 1; }
[[ $(cf push --random-route) ]] || { echo "Test failed: cf push" && exit 1; }
app_route=$(fetch_app_route first-push 0)

[[ $(check_link $app_route; echo $?) = 0 ]] || { echo "Test failed: check_link" && exit 1; }
[[ $(check_link https://buildpacks.io; echo $?) = 0 ]] || { echo "Test failed: check_link" && exit 1; }