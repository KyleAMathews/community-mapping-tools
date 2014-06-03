# Responsible for addresses of families.

config = require '../config'
_ = require 'underscore'

exports.addresses = addresses = []

exports.add = (address) ->
  config.addressesDB.put address['Couple Name'], address
  addToArray(address)

addToArray = (address) ->
  unless _.some(addresses, (add) -> add['Family Address'] is address['Family Address'])
    addresses.push address

# Load everything in db.
config.addressesDB.createReadStream()
  .on('data', (data) ->
    if data?
      addToArray data.value
  )
