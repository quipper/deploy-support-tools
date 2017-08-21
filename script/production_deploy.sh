#!/bin/bash -ex

HEROKU_APPS="quipper-deploy-support-tools"

DEPLOY_SCRIPT=/tmp/deploy.$$.sh
curl https://quipper-deploy-support-tools.herokuapp.com/scripts/v2/production_deploy.sh.txt > ${DEPLOY_SCRIPT}
. ${DEPLOY_SCRIPT}

deploy
