# @cjsx React.DOM

# Responsible for displaying a single family including
# their name, address, distance, and a link to a directions map.

React = require('react')

module.exports = React.createClass(
  render: ->
    return (
      <li>{@props.family['Couple Name']} — {@props.distance.distance} miles
        <br />
        <a
          href="https://maps.google.com?saddr={activeFamily.latLng.lat},{activeFamily.latLng.lng}&daddr={@props.family.latLng.lat},{@props.family.latLng.lng}"
          target="_blank"
          title="Directions to {@props.family['Couple Name']}"
        ><i>{@props.family['Family Address']}</i>
        </a>
      </li>
    )
)
