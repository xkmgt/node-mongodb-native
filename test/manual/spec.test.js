'use strict';
const path = require('path');
const fs = require('fs');
const { EJSON } = require('bson');
const { TestRunnerContext, generateTopologyTests } = require('../functional/spec-runner');

const specPath = process.env.MONGODB_SPEC_PATH;
if (!specPath) {
  console.warn('Missing required environment variable `MONGODB_SPEC_PATH`');
  return process.exit(1);
}

const testContext = new TestRunnerContext();
const testSuites = fs
  .readdirSync(specPath)
  .filter(x => x.indexOf('.json') !== -1)
  .map(x =>
    Object.assign(EJSON.parse(fs.readFileSync(path.join(specPath, x)), { relaxed: true }), {
      name: path.basename(x, '.json')
    })
  );

after(() => testContext.teardown());
before(function () {
  return testContext.setup(this.configuration);
});

generateTopologyTests(testSuites, testContext);
