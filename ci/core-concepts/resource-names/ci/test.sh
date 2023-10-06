#!/bin/bash

set -e

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
repo_root="$(git rev-parse --show-toplevel)"
source "${repo_root}/ci/common-test/links.sh"
source "${repo_root}/ci/common-test/helpers.sh"

function cleanup {
  cf delete -f -r first-push 1> /dev/null || cf delete -f -r renamed-app 1> /dev/null
  echo "Cleanup succeeded"
}
trap cleanup EXIT

cf_auth $CF_API $CF_ORG

cd ${script_dir}/../apps/first-push
[[ $(cf target -o $CF_ORG -s development) ]] || { echo "Test failed: cf target -o $CF_ORG -s development" && exit 1; }
[[ $(cf push --random-route) ]] || { echo "Test failed: cf push" && exit 1; }
[[ $(cf app first-push --guid) ]] || { echo "Test failed: cf app first-push --guid" && exit 1; }
[[ $(cf rename first-push renamed-app) ]] || { echo "Test failed: cf rename first-push renamed-app" && exit 1; }