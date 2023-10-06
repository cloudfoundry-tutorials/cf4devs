#!/bin/bash

set -e

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
repo_root="$(git rev-parse --show-toplevel)"
source "${repo_root}/ci/common-test/links.sh"
source "${repo_root}/ci/common-test/helpers.sh"

function cleanup {
  cf delete -f -r static-app &> /dev/null
  echo "Cleanup succeeded"
}
trap cleanup EXIT

cf_auth $CF_API $CF_ORG

cd ${script_dir}/../apps/static-app
[[ $(cf target -o $CF_ORG -s development) ]] || { echo "Test failed: cf target -o $CF_ORG -s development" && exit 1; }
[[ $(cf push static-app --random-route -p app.zip) ]] || { echo "Test failed: cf push" && exit 1; }
[[ $(check_link https://docs.cloudfoundry.org/concepts/how-applications-are-staged.html; echo $?) = 0 ]] || { echo "Test failed: check_link https://docs.cloudfoundry.org/concepts/how-applications-are-staged.html" && exit 1; }
[[ $(cf restart static-app --strategy rolling) ]] || { echo "Test failed: cf restart static-app --strategy rolling" && exit 1; }
[[ $(cf restart static-app) ]] || { echo "Test failed: cf restart static-app" && exit 1; }
[[ $(cf scale -i 2 static-app -f) ]] || { echo "Test failed: cf scale -i 2 static-app" && exit 1; }
[[ $(cf restart static-app 0) ]] || { echo "Test failed: cf restart static-app 0" && exit 1; }
[[ $(cf restage static-app --strategy rolling) ]] || { echo "Test failed: cf restage static-app --strategy rolling" && exit 1; }
[[ $(cf stacks) ]] || { echo "Test failed: cf stacks" && exit 1; }
[[ $(cf app static-app | grep stack:) ]] || { echo "Test failed: cf app static-app | grep stack:" && exit 1; }
