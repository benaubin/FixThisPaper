React = require 'react'

{div, h3, h4, p, span, input, article, small, div} = r = React.DOM
e = React.createElement

Part1Support = require './parts/1-support'
Part2Explain = require './parts/2-explain'
Part3Javascript = require './parts/3-javascript'
Part4Console = require './parts/4-console'

Terminal = require './terminal'

module.exports =
  class BodyText extends React.Component
    constructor: (props) ->
      super props

      @state =
        part: Part1Support
        parts: [
          Part2Explain
          Part3Javascript
          Part4Console
        ]
        name: undefined
    nextPart: =>
      if part = @state.parts.shift()
        @setState part: part, parts: @state.parts
      else
        @setState {
          part:
            number: @state.part.number + 1
          parts: @state.parts
          end: true
        }
    onCommand: (command) =>
      @currentPartRef()?.onCommand(command)
    partNumber: =>
      @state.part?.number
    currentPartRef: =>
      @refs["part-#{@partNumber()}"]
    onJavascript: (command, output, console, jsObjs) =>
      @currentPartRef().onJavascript command, output, console, jsObjs
    onName: (name) =>
      @setState name: name
    componentDidUpdate: =>
      window.Carnival()
    render: ->
      div null,
        e Part1Support, {
          onDone: @nextPart
          ref: "part-0"
        }
        if @state.part?.number >= 1
          e Part2Explain, {
            onDone: @nextPart
            ref: "part-1"
          }
        if @state.part?.number >= 2
          e Part3Javascript, {
            ref: "part-2"
            onName: @onName
          }
        if @state.part?.number >= 3
          e Part4Console,
            ref: "part-3",
            name: @state.name
        if @state.end
          p className: 'mla', """
            That's all I've written for now. Check back later for more!
          """
        else
          e Terminal, {
            javascript: @state.part?.number >= 2
            onJavascript: @onJavascript
            onDone: @nextPart
            placeholder: @state.part.placeholder
            onCommand: @onCommand
            helpText: @state.part.helpText
          }
