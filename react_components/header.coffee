React = require('react')
_ = require 'underscore'
{div, h1, p, span, i} = React.DOM

module.exports = React.createClass
  render: ->
    if activeFamily?
      distancesCalculated = _.keys(addresses[activeFamily['Family Address']]).length
      console.log activeFamily, distancesCalculated
    return (React.DOM.div null, [
      h1(null, "Who Are Your Neighbors?")
      unless activeFamily?
        p null, "Select your family to find your neighbors!"
      else if activeFamily? and distancesCalculated < 899
        div(className: 'calculating', [
          p null, "Finding the closest neighbors for ", i(null, activeFamily['Couple Name'])
          span null, "#{distancesCalculated} distances calculated out of 899"
        ])
    ])
