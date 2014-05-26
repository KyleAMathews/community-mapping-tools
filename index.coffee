config = require './config'

Hapi = require 'hapi'
Ect = require 'ect'
SocketIO = require('socket.io')

queryForDistancesFromAddress  = require('./lib/query_for_address')

renderer = Ect({ root : __dirname + '/views', ext : '.ect' })

server = Hapi.createServer('localhost', 8000, {
  views:
    engines:
      html: 'swig'
    path: "./views"
})

server.route({
    method: 'GET',
    path: '/address',
    handler: (request, reply) ->
      queryForDistancesFromAddress('1843 9th Ave Apt A San Francisco, California 94122')
      reply('ok')

})
server.route({
    method: 'GET',
    path: '/hello',
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
      console.log request.payload.length
      for address in request.payload
        # Don't save addresses w/o a street address i.e. just
        # "San Francisco, CA"
        if address['Family Address'].trim().length > 31
          config.addressesDB.put address['Couple Name'], address
      reply('ok')
})

# Start the server
server.start ->
  console.log("Hapi server started at " + server.info.uri)
  config.websocket = server.websocket = SocketIO.listen(server.listener)
