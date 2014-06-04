# @cjsx React.DOM

# Responsible for displaying addresses sorted by how close they are to the active
# family.

React = require('react')
_ = require 'underscore'
Family = require './family'

module.exports = React.createClass(
  render: ->
    unless _.isEmpty addresses[activeFamily?['Family Address']]
      origin = activeFamily['Family Address']
    families = []
    for address in _.sortBy(_.values(addresses[origin]), (data) -> data.distance)
      family = _.find window.families, (family) -> family['Family Address'] is address.destination
      families.push <Family key={address.destination} family={family} distance={address} />
    return (
      <div>
        <ol>
          {families}
        </ol>
      </div>
    )
)
