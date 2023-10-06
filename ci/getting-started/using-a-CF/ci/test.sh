#!/bin/bash

set -e

repo_root=$(git rev-parse --show-toplevel)
source ${repo_root}/ci/common-test/links.sh
source "${repo_root}/ci/common-test/helpers.sh"

[[ $(check_link https://www.codecademy.com/articles/what-is-rest; echo $?) = 0 ]] || { echo "Test failed: check_link" && exit 1; }
[[ $(cf api $CF_API | grep "Setting API endpoint to") ]] || { echo "Test failed: cf api $CF_API" && exit 1; }
cf auth 1> /dev/null # cf api <API-URL> logs you out, so we need to re-authenticate
[[ $(cf api | grep "$CF_API") ]] || { echo "Test failed: cf api" && exit 1; }
[[ $(cf login -h | grep -- --sso) ]] || { echo "Test failed: cf login -h shows --sso flag" && exit 1; }
[[ $(cf target) ]] || { echo "Test failed: cf target" && exit 1; }