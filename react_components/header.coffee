# @cjsx React.DOM

# Responsible for rendering header to app.
# Includes the title, so progress indicators when calculating distances, and
# prompts user when they first land to select a family.

React = require('react')
_ = require 'underscore'

module.exports = React.createClass
  render: ->
    if activeFamily?
      distancesCalculated = _.keys(addresses[activeFamily['Family Address']]).length
    else
      blankSlate = <p>Select your family to find your neighbors!</p>

    if activeFamily? and distancesCalculated < 899
      calculating =
        <div className='calculating'>
          <p>Finding the closest neighbors for <i>{activeFamily['Couple Name']}</i></p>
          <span>{distancesCalculated} distances calculated out of 899</span>
        </div>

    return (
      <div>
        <h1>Who Are Your Neighbors?</h1>
        {blankSlate}
        {calculating}
      </div>
    )
