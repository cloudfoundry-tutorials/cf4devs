#!/bin/bash

set -e

repo_root="$(git rev-parse --show-toplevel)"
source "${repo_root}/ci/common-test/helpers.sh"

cf_auth $CF_API $CF_ORG

[[ $(cf org-users $CF_ORG) ]] || { echo "Test failed: cf org-users $CF_ORG" && exit 1; }
[[ $(cf space-users $CF_ORG development) ]] || { echo "Test failed: cf space-users $CF_ORG development" && exit 1; }
[[ $(cf org-users $CF_ORG -a) ]] || { echo "Test failed: cf org-users $CF_ORG -a" && exit 1; }