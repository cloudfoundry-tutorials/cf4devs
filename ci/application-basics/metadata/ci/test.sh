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

function cf_curl_set_annotation {
  app_guid=$(cf app static-app --guid)
  cf curl v3/apps/${app_guid} \
  -X PATCH \
  -d '{
    "metadata": {
      "annotations": {
        "contact": "bob@example.com"
      }
    }
  }'
}

cf_auth $CF_API $CF_ORG

cd ${script_dir}/../apps/static-app
[[ $(cf target -o $CF_ORG -s development) ]] || { echo "Test failed: cf target -o $CF_ORG -s development" && exit 1; }
[[ $(cf push static-app --random-route -p app.zip -f ${script_dir}/updated_manifest.yml) ]] || { echo "Test failed: cf push" && exit 1; }
[[ $(cf set-label app static-app env=prod) ]] || { echo "Test failed: cf set-label app static-app env=prod" && exit 1; }
[[ $(cf labels app static-app | grep prod ) ]] || { echo "Test failed: cf labels app static-app" && exit 1; }
[[ $(cf apps --labels 'env=prod' | grep static-app) ]] || { echo "Test failed: cf apps --labels 'env=prod'" && exit 1; }
[[ $(cf set-label app static-app sensitive=true) ]] || { echo "Test failed: cf set-label app static-app sensitive=true" && exit 1; }
[[ $(cf apps --labels 'env=prod,sensitive=true' | grep static-app | wc -l | xargs) = 1 ]] || { echo "Test failed: cf apps --labels 'env=prod,sensitive=true'" && exit 1; }
[[ $(cf curl /v3/apps/$(cf app static-app --guid) | grep bob@example.com) ]] || { echo "Test failed: cf curl (checking annotation)" && exit 1; }
[[ $(cf delete -f -r static-app) ]] || { echo "Test failed: cf delete" && exit 1; }
[[ $(cf push static-app --random-route -p app.zip) ]] || { echo "Test failed: cf push" && exit 1; }
[[ $(cf_curl_set_annotation) ]] || { echo "Test failed: cf curl (setting annotation)" && exit 1; }
[[ $(cf curl /v3/apps/$(cf app static-app --guid) | grep bob@example.com) ]] || { echo "Test failed: cf curl (checking annotation)" && exit 1; }
[[ $(cf create-app-manifest static-app -p >(cat) | grep bob@example.com) ]] || { echo "Test failed: cf curl (checking annotation)" && exit 1; }