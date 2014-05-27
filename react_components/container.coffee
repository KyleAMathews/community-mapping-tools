FamilySelector = require './family_selector'
SortedAddresses = require './sorted_addresses'
Header = require './header'

React = require('react')

module.exports = React.createClass(
  render: ->
    return (React.DOM.div null, [
      Header()
      FamilySelector()
      SortedAddresses()
    ])
)

