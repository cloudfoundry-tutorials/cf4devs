#!/bin/bash

set -e

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
repo_root="$(git rev-parse --show-toplevel)"
source "${repo_root}/ci/common-test/links.sh"
source "${repo_root}/ci/common-test/helpers.sh"

function cleanup {
  cf delete -f -r training-app &> /dev/null
  echo "Cleanup succeeded"
}
trap cleanup EXIT

cf_auth $CF_API $CF_ORG

[[ $(check_link https://12factor.net/processes; echo $?) = 0 ]] || { echo "Test failed: check_link https://12factor.net/processes" && exit 1; }
cd ${script_dir}/../apps/training-app
[[ $(cf target -o $CF_ORG -s development) ]] || { echo "Test failed: cf target -o $CF_ORG -s development" && exit 1; }
[[ $(cf push training-app --random-route -p training-app.zip -t 10) ]] || { echo "Test failed: cf push" && exit 1; }
[[ $(CF_STAGING_TIMEOUT=0.1 cf push training-app --random-route -p training-app.zip; echo $?) != 0 ]] || { echo "Test failed: CF_STAGING_TIMEOUT=0.1 cf push" && exit 1; }
[[ $(cf delete -f -r training-app) ]] || { echo "Test failed: cf delete -f -r training-app" && exit 1; }
[[ $(CF_STAGING_TIMEOUT=10 cf push training-app --random-route -p training-app.zip) ]] || { echo "Test failed: CF_STAGING_TIMEOUT=10 cf push" && exit 1; }
[[ $(CF_STARTUP_TIMEOUT=0.01 cf push training-app --random-route -p training-app.zip; echo $?) != 0 ]] || { echo "Test failed: CF_STARTUP_TIMEOUT=0.01 cf push" && exit 1; }
[[ $(cf delete -f -r training-app) ]] || { echo "Test failed: cf delete -f -r training-app" && exit 1; }
[[ $(CF_STARTUP_TIMEOUT=10 cf push training-app --random-route -p training-app.zip) ]] || { echo "Test failed: CF_STARTUP_TIMEOUT=10 cf push" && exit 1; }
[[ $(cf push training-app --random-route -p training-app.zip -t 10) ]] || { echo "Test failed: cf push" && exit 1; }
[[ $(check_link https://docs.cloudfoundry.org/devguide/deploy-apps/large-app-deploy.html; echo $?) = 0 ]] || { echo "Test failed: check_link https://docs.cloudfoundry.org/devguide/deploy-apps/large-app-deploy.html" && exit 1; }
