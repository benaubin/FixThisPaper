React = require 'react'

{div, h3, h4, p, span, input, table, thead, tbody, tr, td, th, small, div} = r = React.DOM
e = React.createElement

Part1Support = require './parts/1-support'
Part2Explain = require './parts/2-explain'
Part3Javascript = require './parts/3-javascript'
Part4Console = require './parts/4-console'

Terminal = require './terminal'

parts = [
  Part1Support,
  Part2Explain,
  Part3Javascript,
  Part4Console
]

module.exports =
  class BodyText extends React.Component
    constructor: (props) ->
      super props

      @state =
        part: parts.shift()
        name: undefined
    nextPart: =>
      @setState part: parts.shift()
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
        e Terminal, {
          javascript: @state.part?.number >= 2
          onJavascript: @onJavascript
          onDone: @nextPart
          placeholder: @state.part.placeholder
          onCommand: @onCommand
          helpText: @state.part.helpText
        }
