React = require 'react'
ReactDOM = require 'react-dom'
moment = require 'moment'
$ = require 'jquery'
window.buildTime = require 'timestamp!timestamp-loader'

{div, h3, p, span, input} = r = React.DOM
e = React.createElement

BodyText = require './components/body-text'

$ ->
  $('#date-id').text moment(buildTime).format('MMMM Do, YYYY')
  ReactDOM.render e(BodyText, version: 'v0.10'), $('#body-text')[0]
