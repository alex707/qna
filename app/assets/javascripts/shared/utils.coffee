App = window.App = {}

App.utils =
  render: (template, data) ->
    JST[template](data)
