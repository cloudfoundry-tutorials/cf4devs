#!/bin/bash

set -e

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
repo_root="$(git rev-parse --show-toplevel)"
source "${repo_root}/ci/common-test/links.sh"
source "${repo_root}/ci/common-test/helpers.sh"

function cleanup {
  cf delete -f -r training-app -f 1> /dev/null
  echo "Cleanup succeeded"
}
trap cleanup EXIT

cf_auth $CF_API $CF_ORG

cd ${script_dir}/../apps/training-app
[[ $(cf target -o $CF_ORG -s development) ]] || { echo "Test failed: cf target -o $CF_ORG -s development" && exit 1; }
[[ $(cf push training-app -f manifest.yml -p training-app.zip --random-route) ]] || { echo "Test failed: cf push" && exit 1; }
app_route=$(fetch_app_route training-app 0)
[[ $(check_link $app_route; echo $?) = 0 ]] || { echo "Test failed: check_link $app_route" && exit 1; }
[[ $(cf set-env training-app TRAINING_KEY_1 training-value-1) ]] || { echo "Test failed: cf set-env" && exit 1; }
[[ $(cf set-env training-app TRAINING_KEY_2 training-value-2) ]] || { echo "Test failed: cf set-env" && exit 1; }
[[ $(cf set-env training-app TRAINING_KEY_3 training-value-3) ]] || { echo "Test failed: cf set-env" && exit 1; }
[[ $(cf restart training-app) ]] || { echo "Test failed: cf restart training-app" && exit 1; }
[[ $(curl $app_route --silent | grep TRAINING_KEY_1) ]] || { echo "Test failed: curl $app_route | grep TRAINING_KEY_1" && exit 1; }
[[ $(cf env training-app) ]] || { echo "Test failed: cf env training-app" && exit 1; }
[[ $(cf set-env training-app TRAINING_KEY_3 training-value-3_1) ]] || { echo "Test failed: cf set-env" && exit 1; }
[[ $(cf restart training-app) ]] || { echo "Test failed: cf restart training-app" && exit 1; }
[[ $(curl $app_route --silent | grep training-value-3_1) ]] || { echo "Test failed: curl $app_route | grep TRAINING_KEY_1" && exit 1; }
[[ $(cf delete -f -r training-app) ]] || { echo "cf delete training-app" && exit 1; }
[[ $(cf push training-app -f ${script_dir}/manifest_updated.yml -p training-app.zip --random-route) ]] || { echo "Test failed: cf push" && exit 1; }
app_route=$(fetch_app_route training-app 0)
[[ $(curl $app_route --silent | grep TRAINING_KEY_1) ]] || { echo "Test failed: curl $app_route | grep TRAINING_KEY_1" && exit 1; }
[[ $(cf unset-env training-app TRAINING_KEY_1) ]] || { echo "Test failed: cf unset-env" && exit 1; }
[[ $(cf running-environment-variable-group) ]] || { echo "Test failed: cf running-environment-variable-group" && exit 1; }
[[ $(cf staging-environment-variable-group) ]] || { echo "Test failed: cf staging-environment-variable-group" && exit 1; }