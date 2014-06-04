# @cjsx React.DOM

# Responsible for kicking this thing off.

FamilySelector = require './family_selector'
SortedAddresses = require './sorted_addresses'
Header = require './header'

React = require('react')

module.exports = React.createClass(
  render: ->
    <div>
      <Header />
      <FamilySelector />
      <SortedAddresses />
    </div>
)

