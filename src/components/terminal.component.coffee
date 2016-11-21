React = require 'react'

{div, h3, h4, p, span, input, table, thead, tbody, tr, td, th, small, div} = r = React.DOM
e = React.createElement

newJsObjs = require '../new-js-objs'

module.exports =
  class Terminal extends React.Component
    constructor: (props) ->
      super props
      @state =
        terminalText: ''
        commands: []
        console: []
    handleCommandChange: (e)  =>
      @setState terminalText: e.target.value
    promptChar: =>
      if @props.javascript then ' > ' else ' $ '
    onConsoleLog: (log, type) =>
      console.log(log, type)
      logObject = {log: log, logType: type}
      @state.commands.push logObject
      @setState {
        console: @state.console.concat(logObject)
      }, =>
        terminalInputNode = @terminalNode.getElementsByClassName('terminal-input-row')[0]
        @terminalNode.scrollTop = terminalInputNode.offsetTop
    handleKeyPress: (e) =>
      if e.key == 'Enter'
        unless @state.terminalText
          e.preventDefault()
          return false
        command = {
          text: @state.terminalText,
          promptChar: @promptChar()
        }
        if @props.javascript
          @jsObjs ||= newJsObjs(@onConsoleLog)
          try
            jsOutput = JSJS.EvaluateScript @jsObjs.cx, @jsObjs.glob, command.text
            output = JSJS.identifyConvertValue JSJS.Types.dynamicPtr, jsOutput

            if output?
              command.output = output?.toString() || typeof output

            command = @props.onJavascript command, output, @state.console, @jsObjs
          catch error
            command.error = error.toString()
            console.error "Caught error", error

          @setState {
            commands: @state.commands.concat command
            terminalText: ''
          }, =>
            terminalInputNode = @terminalNode.getElementsByClassName('terminal-input-row')[0]
            @terminalNode.scrollTop = terminalInputNode.offsetTop

          unless command.error?
            @props.onDone()
        else
          if command.text == 'clear'
            command.response = 'Cleared.'
            @setState commands: [command], terminalText: ''
          else
            command.response = @props.onCommand(command.text) ||
              "Unknown command '#{command.text}'. Type `help` for help"
            @setState {
                commands: @state.commands.concat command
                terminalText: ''
              }, =>
                terminalInputNode = @terminalNode.getElementsByClassName('terminal-input-row')[0]
                @terminalNode.scrollTop = terminalInputNode.offsetTop

    render: ->
      div {className: 'terminal', ref: (ref) => @terminalNode = ref},
        for command, i in @state.commands
          if command.logType
            div key: i,
              div className: 'terminal-row',
                span className: "console-log-#{command.logType}",
                  command.log
          else
            div key: i,
              div {className: 'terminal-row'},
                span className: 'prompt', command.promptChar
                span className: 'command', command.text
              if command.output
                div {className: 'terminal-row'},
                  span className: 'output', command.output
              if command.error
                div {className: 'terminal-row'},
                  span className: 'error', command.error
              if command.response
                div {className: 'terminal-row'},
                  span className: 'response', command.response
        div className: 'terminal-input-row',
          span null, @promptChar()
          input {
            value: @state.terminalText
            type: 'text'
            onChange: @handleCommandChange.bind(@)
            placeholder: @props.placeholder
            onKeyPress: @handleKeyPress.bind(@)
          }
