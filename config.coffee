Levelup = require 'levelup'
levelHUD = require('levelhud')
addressesDB = Levelup './addressesDB', { valueEncoding: 'json' }
distancesDB = Levelup './distancesDB', { valueEncoding: 'json' }

unless process.env.ENVIRONMENT is "production"
  new levelHUD().use(addressesDB).listen(4420)
  new levelHUD().use(distancesDB).listen(4421)

module.exports =
  addressesDB: addressesDB
  distancesDB: distancesDB
