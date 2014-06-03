unless process.env.MAPQUEST_API_KEY?
  console.log "Must run app with MAPQUEST_API_KEY set as an environment variable."
  process.exit()

config = require './config'
geocode = require './lib/geocode'

Hapi = require 'hapi'
Ect = require 'ect'
SocketIO = require('socket.io')

queryForDistancesFromAddress  = require('./lib/query_for_address')

renderer = Ect({ root : __dirname + '/views', ext : '.ect' })

server = Hapi.createServer('0.0.0.0', 8080, {
  views:
    engines:
      html: 'swig'
    path: "./views"
})

# Use HTTP Basic Auth for authentication
validate = (username, password, callback) ->
  console.log username, password
  if username is "happy day" and password is "the sun"
    callback(null, true, id: 'the user yo', name: 'their name')

server.pack.require 'hapi-auth-basic', (err) ->
  server.auth.strategy('simple', 'basic', { validateFunc: validate })

server.route({
    method: 'POST',
    path: '/address',
    handler: (request, reply) ->
      if request.payload?.family?
        queryForDistancesFromAddress(request.payload.family)
      reply('ok')
})
server.route({
    method: 'GET',
    path: '/families',
    handler: (request, reply) ->
      addresses = []
      config.addressesDB.createReadStream()
        .on('data', (data) ->
          addresses.push data.value
        )
        .on('end', ->
          reply(addresses)
        )
})
server.route({
    method: 'GET',
    path: '/hello',
    config:
      auth: 'simple'
    handler: (request, reply) ->
      reply.view('hello')
})
server.route({
    method: 'GET',
    path: '/import',
    handler: (request, reply) ->
      reply.view('import')
})
server.route({
    method: 'GET',
    path: '/static/{path*}',
    handler:
      directory:
        path: "./public"
        listing: false
        index: false
})
server.route({
    method: 'POST',
    path: '/csv',
    config:
      payload:
        parse: true
    handler: (request, reply) ->
      # Write csv to file
      # parse and put into leveldb
      for address in request.payload
        # Don't save addresses w/o a street address i.e. just
        # "San Francisco, CA"
        if address['Family Address'].trim().length > 31
          # Geocode address.
          do (address, config) ->
            geocode(address['Family Address'], (err, latLng) ->
              address.latLng = latLng
              config.addressesDB.put address['Couple Name'], address
            )

      reply('ok')
})

# Start the server
server.start ->
  console.log("Hapi server started at " + server.info.uri)
  config.websocket = server.websocket = SocketIO.listen(server.listener, log: false)
