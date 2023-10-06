#!/bin/bash

set -e

[[ $(cf target -o $CF_ORG -s development) ]] || { echo "Test failed: cf target -o $CF_ORG -s development" && exit 1; }
[[ $(cf staging-security-groups) ]] || { echo "Test failed: cf staging-security-groups" && exit 1; }
[[ $(cf running-security-groups) ]] || { echo "Test failed: cf running-security-groups" && exit 1; }
security_group_name=$(cf curl /v3/security_groups?globally_enabled_running=true | jq --raw-output '.resources[0].name')
[[ $(cf security-group $security_group_name | grep protocol) ]] || { echo "Test failed: cf security-group $security_group_name" && exit 1; }
[[ $(cf bind-security-group $security_group_name $CF_ORG --space development) ]] || { echo "Test failed: cf bind-security-group $security_group_name $CF_ORG --space development" && exit 1; }
[[ $(cf bind-security-group $security_group_name $CF_ORG --space development --lifecycle staging) ]] || { echo "Test failed: cf bind-security-group $security_group_name $CF_ORG --space development --lifecycle staging" && exit 1; }
[[ $(cf unbind-security-group $security_group_name $CF_ORG development --lifecycle running) ]] || { echo "Test failed: cf unbind-security-group $security_group_name $CF_ORG development --lifecycle running" && exit 1; }
[[ $(cf unbind-security-group $security_group_name $CF_ORG development --lifecycle staging) ]] || { echo "Test failed: cf unbind-security-group $security_group_name $CF_ORG development --lifecycle staging" && exit 1; }