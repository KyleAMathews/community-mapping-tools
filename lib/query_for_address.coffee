# Queue and query for distances from a family.

families = require './families'

_ = require 'underscore'
async = require 'async'
request = require 'request'
Levelup = require 'levelup'

config = require '../config'

pairsToFetch = []
module.exports = (family) ->
  console.log "Querying distances to #{families.addresses.length} families"
  # Empty out array for new fetch.
  pairsToFetch = []
  processUncachedPairs = _.after(families.addresses.length, queryDistance)
  for family2 in families.addresses
    if family['Family Address'] is family2['Family Address']
      processUncachedPairs()
    else
      # Check if distance already in DB.
      do (family, family2, config) ->
        config.distancesDB.get("#{family['Family Address']} || #{family2['Family Address']}", (err, value) ->
          # If the key isn't found, ask MapQuest to calculate it.
          if err?.notFound
            pairsToFetch.push { origin: family, destination: family2 }
            processUncachedPairs()
          else
            config.websocket.sockets.emit('distance', value)
            processUncachedPairs()
        )

MAPQUEST_URL = "http://open.mapquestapi.com/directions/v2/routematrix?key=#{process.env.MAPQUEST_API_KEY}"
queryDistance = ->
  console.log "pairs to fetch: #{pairsToFetch.length}"
  async.mapLimit(pairsToFetch, 35, (pair, callback) ->
    do (config, pair, MAPQUEST_URL, callback) ->
      locations = []
      locations.push latLng: pair.origin.latLng
      locations.push latLng: pair.destination.latLng
      options =
        method: 'POST'
        url: MAPQUEST_URL
        json:
          locations: locations
          options:
            allToAll: false
      request(options, (err, res, data) ->
        unless err or !data.distance?
          distance =
            origin: pair.origin['Family Address']
            destination: pair.destination['Family Address']
            distance: data.distance[1]
            time: data.time[1]
          config.websocket.sockets.emit('distance', distance)
          config.distancesDB.put "#{distance.origin} || #{distance.destination}", distance

          # Save the opposite route by reversing the origin / destination in the data.
          origin = distance.destination
          destination = distance.origin
          distance.origin = origin
          distance.destination = destination
          config.distancesDB.put "#{distance.origin} || #{distance.destination}", distance
          callback err, distance
        else
          console.log err
      )
  )
