#!/usr/bin/env bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
DRIVER_DIR=$(readlink -f "$SCRIPT_DIR/../../..")

# make a temporary directory for building the driver and running tests
WORK_DIR=$(mktemp -d -t ci-$(date +%Y-%m-%d-%H-%M-%S)-XXXXXXXXXX)

# copy the spec tests to a well known path
mkdir -p $WORK_DIR/spec-tests
cp $SCRIPT_DIR/../../spec/crud/v2/*.json $WORK_DIR/spec-tests

# run the docker tests
sudo docker run \
  --interactive \
  --network=host \
  --volume $DRIVER_DIR:/origin:ro \
  --volume $WORK_DIR:/work \
  --workdir=/work \
  ubuntu:18.04 \
  /origin/test/tools/automated-spec-tester/automated-spec-test.sh

# Report findings
printf "\n\n\nTEST RUN COMPLETE, RESULTS:"
cat $WORK_DIR/RESULTS.xml

# cleanup
sudo rm -rf $WORK_DIR
