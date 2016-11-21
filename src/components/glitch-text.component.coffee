React = require 'react'

{div, h3, h4, p, span, input, strong, small, br, div, hr} = r = React.DOM
e = React.createElement

module.exports =
  class GlitchText extends React.Component
    render: ->
      className = @props.className
      className = className + ' glitch' unless @props.stopGlitch
      p className: className, 'data-text': @props.text, @props.text
