// Allows us to use ES6 in our migrations and tests.
require('babel-register')

module.exports = {
  networks: {
    development: {
      // host can be the following or 'localhost'
      host: '127.0.0.1',
      port: 8545,
      gas: 6000000,
      network_id: '*' // Match any network id
    }
  }
}
