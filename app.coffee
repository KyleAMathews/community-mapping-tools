React = require('react')

SortedAddresses = require './react_components/sorted_addresses'

window.a = addresses = {}

socket = io.connect('http://localhost')
socket.on('address', (data) ->
  unless addresses[data.origin]? then addresses[data.origin] = {}
  unless addresses[data.origin][data.destination]?
    addresses[data.origin][data.destination] = data
    render()
)

render = ->
  console.log 'rendering'
  React.renderComponent(SortedAddresses(addresses: addresses), document.body)

render()
