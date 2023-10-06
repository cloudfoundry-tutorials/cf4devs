#!/bin/bash

set -e

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
repo_root="$(git rev-parse --show-toplevel)"
source "${repo_root}/ci/common-test/links.sh"
source "${repo_root}/ci/common-test/helpers.sh"

function cleanup {
  cf delete -f -r updating-app &> /dev/null
  echo "Cleanup succeeded"
}
trap cleanup EXIT

cf_auth $CF_API $CF_ORG

cd ${script_dir}/../apps/updating-app
[[ $(cf target -o $CF_ORG -s development) ]] || { echo "Test failed: cf target -o $CF_ORG -s development" && exit 1; }
[[ $(cf push updating-app --random-route) ]] || { echo "Test failed: cf push" && exit 1; }
[[ $(cf push updating-app --random-route --strategy rolling) ]] || { echo "Test failed: cf push" && exit 1; }
[[ $(cf push updating-app --random-route --strategy rolling --no-wait) ]] || { echo "Test failed: cf push" && exit 1; }
[[ $(cf cancel-deployment updating-app) ]] || { echo "Test failed: cf cancel-deployment updating-app" && exit 1; }
