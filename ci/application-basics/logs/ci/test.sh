#!/bin/bash

set -e

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
repo_root="$(git rev-parse --show-toplevel)"
source "${repo_root}/ci/common-test/links.sh"
source "${repo_root}/ci/common-test/helpers.sh"

function cleanup {
  cf delete -f -r training-app 1> /dev/null
  echo "Cleanup succeeded"
}
trap cleanup EXIT

cf_auth $CF_API $CF_ORG

cd ${script_dir}/../apps/training-app
[[ $(cf target -o $CF_ORG -s development) ]] || { echo "Test failed: cf target -o $CF_ORG -s development" && exit 1; }
[[ $(cf push training-app --random-route -p training-app.zip -f manifest.yml) ]] || { echo "Test failed: cf push" && exit 1; }
[[ $(timeout -s SIGINT 5 cf logs training-app) ]] || { echo "cf logs training-app" && exit 1; }
app_route=$(fetch_app_route training-app 0)
[[ $(check_link $app_route; echo $?) = 0 ]] || { echo "Test failed: check_link $app_route" && exit 1; }
[[ $(cf logs --recent training-app | grep \[RTR\/\d+\]) ]] || { echo "cf logs --recent training-app" && exit 1; }
[[ $(check_link https://github.com/cloudfoundry/cf-drain-cli; echo $?) = 0 ]] || { echo "Test failed: check_link https://github.com/cloudfoundry/cf-drain-cli" && exit 1; }
[[ $(cf events training-app) ]] || { echo "cf events training-app" && exit 1; }




