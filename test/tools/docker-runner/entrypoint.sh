echo "Getting ${DRIVER_REPOSITORY}@${DRIVER_REVISION}..."
git clone -b v${DRIVER_VERSION} $DRIVER_REPOSITORY driver_src
cd driver_src

# Install desired LTS version of Node
# Note - can extend this logic to support non-LTS versions of node, if desired
NVM_DIR=/root/.nvm
curl https://raw.githubusercontent.com/creationix/nvm/v0.35.3/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install --lts=$NODE_LTS_NAME \
    && npm install

# Run the tests with the provided MONGODB_URI
MONGODB_URI=${MONGODB_URI} npm run test
