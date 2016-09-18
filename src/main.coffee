React = require 'react'
ReactDOM = require 'react-dom'

{div, h3, p, span, input} = r = React.DOM
e = React.createElement

BodyText = require './components/body-text'

window.onload = ->
  ReactDOM.render e(BodyText), document.getElementById 'body-text'
