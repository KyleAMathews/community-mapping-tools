React = require 'react'
CSV = require 'csv'
request = require 'superagent'

{input} = React.DOM

FileImport = React.createClass(
  handleFile: (event) ->
    files = event.nativeEvent.target.files
    reader = new FileReader()
    reader.readAsText(files[0])
    reader.onload = (event) ->
      csv = event.target.result
      CSV.parse(csv, {columns: true}, (err, data) ->
        request.post('/csv', data, (err, res) ->
        )
      )

  render: ->
    return (
      input type: 'file', onChange: @handleFile
    )
)

React.renderComponent(FileImport(), document.body)
