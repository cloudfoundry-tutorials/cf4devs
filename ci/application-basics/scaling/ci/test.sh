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
[[ $(cf scale -i 2 static-app -f) ]] || { echo "Test failed: cf scale -i 2 static-app" && exit 1; }
[[ $(cf curl /v3/apps/$(cf app static-app --guid)/processes | jq '.resources[0].instances') = 2 ]] || { echo "Test failed: validating scale-up to 2 instances" && exit 1; }
[[ $(cf scale -m 48M -k 256M static-app -f) ]] || { echo "Test failed: cf scale -m 48M -k 256M static-app" && exit 1; }
[[ $(cf app static-app | grep 48M | grep 256M) ]] || { echo "Test failed: validating vertical scale-up" && exit 1; }
[[ $(cf delete -f -r static-app) ]] || { echo "Test failed: cf delete" && exit 1; }
[[ $(cf push static-app --random-route -p app.zip -f ${script_dir}/updated_manifest.yml) ]] || { echo "Test failed: cf push" && exit 1; }
[[ $(check_link 'https://github.com/cloudfoundry/app-autoscaler'; echo $?) = 0 ]] || { echo "Test failed: check_link 'https://github.com/cloudfoundry/app-autoscaler'" && exit 1; }
