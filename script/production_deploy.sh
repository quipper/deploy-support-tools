#!/bin/bash -e

DEPLOY_SCRIPT=/tmp/deploy.$$.sh
curl https://quipper-deploy-support-tools.herokuapp.com/scripts/production_deploy.sh.txt > ${DEPLOY_SCRIPT}
. ${DEPLOY_SCRIPT}

HEROKU_APPS="quipper-heroku-support-tools"

deploy
