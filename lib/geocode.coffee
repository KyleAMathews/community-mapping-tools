request = require 'request'

MAPQUEST_URL = "http://www.mapquestapi.com/geocoding/v1/address?&key=#{process.env.MAPQUEST_API_KEY}&location="

module.exports = (address, callback) ->
  request.post({
      url: MAPQUEST_URL + encodeURIComponent(address)
    }, (err, request, body) ->
      body = JSON.parse body
      callback err, body.results[0].locations[0].latLng
  )
