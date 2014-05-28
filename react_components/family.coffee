# Responsible for displaying a single family including
# their name, address, distance, and a link to a directions map.

React = require('react')
{div, a, h2, ol, li, br, i, span} = React.DOM

module.exports = React.createClass(
  render: ->
    li null, [
      "#{@props.family['Couple Name']} — #{@props.distance.distance} miles"
      br()
      a({
        href: "https://maps.google.com?saddr=#{activeFamily.latLng.lat},#{activeFamily.latLng.lng}&daddr=#{@props.family.latLng.lat},#{@props.family.latLng.lng}"
        target: "_blank"
        title: "Directions to #{@props.family['Couple Name']}"
      },
        i(null, "#{@props.family['Family Address']}")
      )
    ]
)
