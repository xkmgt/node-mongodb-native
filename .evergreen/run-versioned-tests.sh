#!/bin/bash
# set -o xtrace   # Write all commands first to stderr
set -o errexit  # Exit the script with error if any of the commands fail

DRIVER_VERSION=$1
echo "MONGODB_URI=$MONGODB_URI VERSION=$VERSION TOPOLOGY=$TOPOLOGY AUTH=$AUTH SSL=$SSL"
echo "PLATFORM=$PLATFORM DRIVER_VERSION=$DRIVER_VERSION"

ADDITIONAL_DEPS=:

export PROJECT_DIRECTORY=$(cd $(dirname ${BASH_SOURCE[0]}) && cd .. && pwd)
export NODE_LTS_NAME=dubnium
export SKIP_INSTALL=1

if [[ $OS == "Windows_NT" || $PLATFORM == "windows-64" ]]; then
  export PROJECT_DIRECTORY=`cygpath -w "$PROJECT_DIRECTORY"`
fi

echo "PROJECT_DIRECTORY=$PROJECT_DIRECTORY NODE_LTS_NAME=$NODE_LTS_NAME"

cd $PROJECT_DIRECTORY

echo "1. Installing driver dependencies"
bash .evergreen/install-dependencies.sh

echo "2. Driver dependencies installed, running test suite"
case $DRIVER_VERSION in
  '3.6')
    TEST_COMMAND='npm run test-nolint'
    ;;
  'NODE-1458/3.6/support-windows-evergreen')
    TEST_COMMAND='npm run test-nolint -- --exit'
    ;;
  '3.3')
    TEST_COMMAND='npm run test-nolint'
    ;;
  'NODE-1458/3.3/support-windows-evergreen')
    TEST_COMMAND='npm run test-nolint -- --exit'
    ;;
  '3.1')
    if [[ $TOPOLOGY == "server" ]]; then
      MONGODB_ENVIRONMENT='single'
    else
      MONGODB_ENVIRONMENT=$TOPOLOGY
    fi
    export MONGODB_ENVIRONMENT
    export MONGODB_VERSION=$VERSION
    ADDITIONAL_DEPS="npm install emadum/mongodb-test-runner#continuous-matrix-testing"
    TEST_COMMAND="./node_modules/.bin/mongodb-test-runner -s -l test/unit test/functional"
    ;;
  *)
    echo "Unsupported driver version: $DRIVER_VERSION"
    exit 1
    ;;
esac

echo "Testing NodeJS driver $DRIVER_VERSION"
echo "TEST_COMMAND=$TEST_COMMAND"

git checkout $DRIVER_VERSION
echo "3. Checked out version branch, running dependency installation"

npm install --unsafe-perm
echo "4. Library dependencies installed, running test suite"
$ADDITIONAL_DEPS
$TEST_COMMAND
