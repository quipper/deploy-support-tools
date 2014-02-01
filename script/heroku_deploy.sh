#!/bin/bash -e

if [ "${CIRCLECI}" == "" ]; then
  echo 'not in CircleCI env'
  exit 1
fi

if [ "${HEROKU_API_TOKEN}" == "" ]; then
  echo "HEROKU_API_TOKEN is not set in CircleCI env. set here https://circleci.com/gh/${CIRCLE_PROJECT_USERNAME}/${CIRCLE_PROJECT_REPONAME}/edit#env-vars"
  exit 1
fi

if [ ! -f "${HOME}/.ssh/id_heroku.com.pub" ]; then
  echo "SSH is not set for Heroku in CircleCI. set here https://circleci.com/gh/${CIRCLE_PROJECT_USERNAME}/${CIRCLE_PROJECT_REPONAME}/edit#ssh"
  exit 1
fi

cat > ${HOME}/.netrc <<EOF
machine api.heroku.com
  login jenkins@quipper.com
  password ${HEROKU_API_TOKEN}
EOF
chmod 600 ${HOME}/.netrc

if [ "${CIRCLE_BRANCH}" == "master" ]; then
  git remote add heroku git@heroku.com:quipper-heroku-support-tools.git
  git fetch heroku
  git push -f heroku ${CIRCLE_SHA1}:refs/heads/master
fi
