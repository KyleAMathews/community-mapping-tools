Levelup = require 'levelup'
if process.env.DOCKER
  addressesDB = Levelup '/data/addressesDB', { valueEncoding: 'json' }
  distancesDB = Levelup '/data/distancesDB', { valueEncoding: 'json' }
else
  addressesDB = Levelup './addressesDB', { valueEncoding: 'json' }
  distancesDB = Levelup './distancesDB', { valueEncoding: 'json' }

unless process.env.NODE_ENV is "production"
  levelHUD = require('levelhud')
  new levelHUD().use(addressesDB).listen(4420)
  new levelHUD().use(distancesDB).listen(4421)

module.exports =
  addressesDB: addressesDB
  distancesDB: distancesDB
