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

cd ${script_dir}/../apps/training-app
[[ $(cf target -o $CF_ORG -s development) ]] || { echo "Test failed: cf target -o $CF_ORG -s development" && exit 1; }
[[ $(cf push training-app --random-route -p training-app.zip) ]] || { echo "Test failed: cf push" && exit 1; }
[[ $(cf routes) ]] || { echo "Test failed: cf routes" && exit 1; }
app_route=$(fetch_app_route training-app 0)
[[ $(cf unmap-route training-app $app_route) ]] || { echo "Test failed: cf unmap-route training-app $app_route" && exit 1; }
[[ $(cf map-route training-app $app_route) ]] || { echo "Test failed: cf map-route training-app $app_route" && exit 1; }
random_host=$(uuidgen)
[[ $(cf push training-app -n $random_host -p training-app.zip) ]] || { echo "Test failed: cf push" && exit 1; }
[[ $(cf env training-app) ]] || { echo "Test failed: cf env training-app" && exit 1; }
[[ $(cf events training-app) ]] || { echo "Test failed: cf events training-app" && exit 1; }
[[ $(cf logs training-app --recent) ]] || { echo "Test failed: cf logs training-app --recent" && exit 1; }
[[ $(cf enable-ssh training-app) ]] || { echo "Test failed: cf enable-ssh training-app" && exit 1; }
[[ $(cf ssh training-app -c date) ]] || { echo "Test failed: cf ssh training-app -c date" && exit 1; }