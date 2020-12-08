'use strict';

/**
 * Filter for tests that require or don't support SSL
 *
 * example:
 * metadata: {
 *    requires: {
 *      ssl: true // only run test if SSL is enabled
 *      ssl: false // only run test if SSL is not enabled
 *    }
 * }
 */
class SSLFilter {
  constructor() {
    // Get environmental variables that are known
    this.ssl = !!(process.env.SSL_KEY_FILE && process.env.SSL_CA_FILE);
  }

  filter(test) {
    if (!test.metadata) return true;
    if (!test.metadata.requires) return true;
    const ssl = test.metadata.requires.ssl;
    if (typeof ssl !== 'boolean') return true;
    if (this.ssl === ssl) return true;
    return false;
  }
}

module.exports = SSLFilter;
