# @cjsx React.DOM

# Responsible for the active family selector.

React = require('react')

module.exports = React.createClass(
  handleChange: (event) ->
    e = @getDOMNode()
    newFamilyName = e.options[e.selectedIndex].text
    changeActiveFamily(newFamilyName)

  render: ->
    options = [<option value=""></option>]
    if families?
      for family in families
        if family['Couple Name']?
          options.push <option value={family['Couple Name']}>{family['Couple Name']}</option>

    return (
      <select onChange={@handleChange}>
        {options}
      </select>
    )
)
