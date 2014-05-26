distance = require 'google-distance'
_ = require 'underscore'
Levelup = require 'levelup'
RateLimiter = require('limiter').RateLimiter
limiter = new RateLimiter(10, 10000)

config = require '../config'

addresses = []
config.addressesDB.createReadStream()
  .on('data', (data) ->
    if data?
      addresses.push data.value['Family Address']
  )

pairsToFetch = []
module.exports = (address) ->
  console.log address
  address = address.trim()
  console.log addresses.length
  processUncachedPairs = _.after(addresses.length, queryGoogle)
  for address2 in addresses
    address2 = address2.trim()
    if address is address2
      processUncachedPairs()
    else
      # Check if distance already in DB.
      do (address, address2, config) ->
        config.distancesDB.get("#{address} || #{address2}", (err, value) ->
          # If the key isn't found, ask Google to calculate it.
          if err?.notFound
            pairsToFetch.push { origin: address, destination: address2 }
            processUncachedPairs()
          else
            console.log 'cache hit'
            config.websocket.sockets.emit('address', value)
            console.log value
            processUncachedPairs()
        )

queryGoogle = ->
  while pairsToFetch.length > 0
    limiter.removeTokens(1, (err, remainingRequests) ->
      console.log 'remaining: ' + remainingRequests
      unless err
        pair = pairsToFetch.pop()
        do (config, pair) ->
          console.log 'inside yo'
          console.log pair
          distance.get({
              origin: pair.origin
              destination: pair.destination
              units: 'imperial'
              mode: 'walking'
            }, (err, data) ->
              console.log err
              unless err
                console.log data,pair
                console.log "origin: #{address} destination: #{address2}"
                config.websocket.sockets.emit('address', data)
                process.exit()
                console.log data.distance
                console.log ''
                config.distancesDB.put "#{pair.origin} || #{pair.destination}", data

                # Save the opposite route by reversing the origin / destination in the data.
                origin = data.destination
                destination = data.origin
                data.origin = origin
                data.destination = destination
                config.distancesDB.put "#{pair.destination} || #{pair.origin}", data
            )
    )
