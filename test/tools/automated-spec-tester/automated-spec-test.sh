#!/usr/bin/env bash
MONGODB_URI=${MONGODB_URI:"mongodb://localhost:27017/"}
NODE_LTS_NAME=${NODE_LTS_NAME:-erbium}
DRIVER_VERSION=${DRIVER_VERSION:-automated-spec-testing}
DRIVER_REPO="https://github.com/mongodb/node-mongodb-native"
PROJECT_DIRECTORY=${PROJECT_DIRECTORY:-"/work"}
export MONGODB_SPEC_PATH=$PROJECT_DIRECTORY/spec-tests

# install essential packages
apt-get update -qq > /dev/null
apt-get install -y -qq --no-install-recommends sudo git curl ca-certificates > /dev/null

# clone driver source, and checkout the requested revision
git clone --depth 1 "$DRIVER_REPO" --branch $DRIVER_VERSION $PROJECT_DIRECTORY/src
pushd $PROJECT_DIRECTORY/src

# install driver dependencies
source .evergreen/install-dependencies.sh

# run tests and output xunit results
npx mocha test/manual/spec.test.js --reporter xunit --reporter-option output=$PROJECT_DIRECTORY/RESULTS.xml
