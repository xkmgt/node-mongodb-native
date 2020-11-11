echo "Getting ${DRIVER_REPOSITORY}@${DRIVER_REVISION} version ${DRIVER_VERSION}"
git clone --depth 1 -b v${DRIVER_VERSION} $DRIVER_REPOSITORY driver_src
cd driver_src

# Install desired LTS version of Node
# Note - can extend this logic to support non-LTS versions of node, if desired
NVM_DIR=/root/.nvm
curl https://raw.githubusercontent.com/creationix/nvm/v0.35.3/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install --no-progress --lts=$NODE_LTS_NAME \
    && npm install

# Run the tests with the provided MONGODB_URI
if [ $DRIVER_VERSION == "3.3.0" ]; then
  echo "Old version, running special test script"
  ./node_modules/.bin/mongodb-test-runner -s -l -e single test/core test/unit test/functional
else
  MONGODB_URI=${MONGODB_URI} npx mocha --recursive test/functional test/unit
fi
