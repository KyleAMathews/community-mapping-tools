React = require('react')
_ = require 'underscore'
{div, h1, h2, ol, li} = React.DOM
pkg = require('../package.json')

module.exports = React.createClass(
  render: ->
    console.log @props
    return (
      unless _.isEmpty @props.addresses
        origin = _.keys(@props.addresses)[0]
        div className: 'yo',
          h2 null, "Distances from #{origin}"
          ol null,
            for address in _.sortBy(_.values(@props.addresses[origin]), (data) -> data.distanceValue)
              li key: address.destination, "#{address.destination}: #{address.distance}"
      else
        h2 null, "No data yet"
    )
)
