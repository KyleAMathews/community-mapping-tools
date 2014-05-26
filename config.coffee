Levelup = require 'levelup'

module.exports =
  addressesDB: Levelup './addressesDB', { valueEncoding: 'json' }
  distancesDB: Levelup './distancesDB', { valueEncoding: 'json' }
