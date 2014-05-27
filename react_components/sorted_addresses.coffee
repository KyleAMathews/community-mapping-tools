React = require('react')
_ = require 'underscore'
{div, h1, h2, ol, li} = React.DOM
pkg = require('../package.json')
Family = require './family'

module.exports = React.createClass(
  render: ->
    unless _.isEmpty addresses[activeFamily?['Family Address']]
      origin = activeFamily['Family Address']
    return (
      div {},
        ol null,
          for address in _.sortBy(_.values(addresses[origin]), (data) -> data.distance)
            family = _.find window.families, (family) -> family['Family Address']  is address.destination
            Family(key: address.destination, family: family, distance: address)
    )
)
