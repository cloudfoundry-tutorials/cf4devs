#!/bin/bash

set -e

repo_root=$(git rev-parse --show-toplevel)
source ${repo_root}/ci/common-test/links.sh
source "${repo_root}/ci/common-test/helpers.sh"

[[ $(cf help | grep "apps,a") ]]
[[ $(cf help -a | grep "SERVICE ADMIN:") ]] || { echo "Test failed: cf help -a" && exit 1; }
[[ $(cf push -h | grep 'cf push APP_NAME [-b BUILDPACK_NAME]') ]] || { echo "Test failed: cf push -h" && exit 1; }
[[ $(cf help -a | grep "INSTALLED PLUGIN COMMANDS") ]] || { echo "Test failed: cf help -a shows installed plugins section" && exit 1; }

[[ $(cf help | grep "Services integration:") ]] || { echo "Test failed: cf help shows `Services integration:` section" && exit 1; }
[[ $(cf help | grep "marketplace,m") ]] || { echo "Test failed: cf help shows marketplace alias" && exit 1; }

[[ $(check_link https://docs.cloudfoundry.org/cf-cli/getting-started.html#i18n; echo $?) = 0 ]] || { echo "Test failed: check_link" && exit 1; }

cf config --locale de-DE 1> /dev/null
[[ $(cf help | grep "Anwendungslebenszyklus:") ]] || { echo "Test failed: cf locale and help showing German" && exit 1; }

cf config --locale CLEAR 1> /dev/null
[[ $(cf help | grep "Application lifecycle:") ]] || { echo "Test failed: clearing locale failed" && exit 1; }

