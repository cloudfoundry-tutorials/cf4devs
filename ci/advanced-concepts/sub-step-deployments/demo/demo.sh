set -e

source ${DEMO_MAGIC_PATH}/demo-magic.sh 

this_directory=$(dirname "$0")

pushd ${this_directory}/../../../../applications/training-app

  start_demo

    pe "cf create-app training-app"
    pe "cf app training-app"

    pe "cf apply-manifest -f manifest.yml"
    pe "cf app training-app"

    pe "cf create-package training-app -p training-app.zip"
    pe "cf packages training-app"

    app_guid=$(cf app --guid training-app)
    package_guid=$(cf curl "/v3/apps/${app_guid}/packages" | jq -r '.resources[0].guid')
    pe "cf stage training-app --package-guid $package_guid"
    pe "cf droplets training-app"

    droplet_guid=$(cf curl "/v3/apps/${app_guid}/droplets" | jq -r '.resources[0].guid')
    pe "cf set-droplet training-app $droplet_guid"
    pe "cf start training-app"

  end_demo
popd