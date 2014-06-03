Container = require './react_components/container'

React = require('react')
request = require 'superagent'
window._ = _ = require 'underscore'

request.get('/families', (err, data) ->
  window.families = data.body
  throttledRender()
)

window.addresses = addresses = {}
window.changeActiveFamily = (newActiveFamily) ->
  family = _.find families, (fam) -> fam['Couple Name'] is newActiveFamily

  # Set global active family.
  window.activeFamily = family

  # Trigger pushing of distances for this family.
  request.post('/address', family: family, (err, res) ->
    console.log err, res
  )

  throttledRender()

socket = io()
socket.on('distance', (data) ->
  unless addresses[data.origin]? then addresses[data.origin] = {}
  unless addresses[data.origin][data.destination]?
    addresses[data.origin][data.destination] = data
    throttledRender()
)

render = ->
  console.log 'rendering'
  React.renderComponent(Container(), document.body)

throttledRender = _.throttle render, 500
render()
