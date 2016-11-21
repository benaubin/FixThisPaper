React = require 'react'

{div, h3, h4, p, span, input, strong, small, br, div, hr} = r = React.DOM
e = React.createElement

module.exports =
  class Part1Support extends React.Component
    render: ->
      helpBoxClassName = 'help-box'
      helpBoxClassName += ' screen-hidden' if @props.hidden

      div className: helpBoxClassName, role: 'alert',
        strong null, @props.title
        div null, @props.children
