React = require('react')

{select, option} = React.DOM

module.exports = React.createClass(
  handleChange: (event) ->
    e = @getDOMNode()
    newFamilyName = e.options[e.selectedIndex].text
    changeActiveFamily(newFamilyName)

  render: ->
    return (
      select onChange: @handleChange,
        if families?
          for family in families
            if family['Couple Name']?
              option value: family['Couple Name'], family['Couple Name']
    )
)
