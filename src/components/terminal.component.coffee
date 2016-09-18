React = require 'react'

{div, h3, h4, p, span, input, table, thead, tbody, tr, td, th, small, div} = r = React.DOM
e = React.createElement

# JSJS.SetErrorReporter(jsObjs.cx, JSJS.wrapFunction {
#   func: (message) ->
#
#   args: [JSJS.Types.dynamicPtr, JSJS.Types.dynamicPtr, JSJS.Types.dynamicPtr]
#   returns: nullitt
# }function(a, b, c){
#   console.warn(
#     ,
#     JSJS.identifyConvertValue(JSJS.Types.dynamicPtr, b),
#     JSJS.identifyConvertValue(JSJS.Types.dynamicPtr, c)
#   );
# })

newJsObjs = ((JSJS) ->
  (onConsoleLog) ->
    jsObjs = JSJS.Init()

    fakeConsoleLog = JSJS.wrapFunction {
      func: (message) ->
        (console.log)(message)
        return
      args: [JSJS.Types.dynamicPtr]
      returns: null
    }

    ptrFakeConsoleLog = JSJS.NewFunction jsObjs.cx, fakeConsoleLog, 1, 'log'

    consoleGetProperty = (prop) ->
      switch prop
        when 'log' then { type: JSJS.Types.funcPtr, val: ptrFakeConsoleLog }
        else
          return true

    consoleClass = JSJS.CreateClass JSJS.JSCLASS_GLOBAL_FLAGS,
      JSJS['PropertyStub'], JSJS['PropertyStub'], JSJS.wrapGetter( consoleGetProperty, JSJS.Types.bool),
      JSJS['StrictPropertyStub'], JSJS['EnumerateStub'], JSJS.wrapResolver (propName) ->
        (['log']).indexOf(propName) != -1
      JSJS['ConvertStub'], JSJS['FinalizeStub']
    jsConsole = JSJS.DefineObject jsObjs.cx, jsObjs.glob, "console", consoleClass

    jsObjs
)(window.JSJS)

module.exports =
  class Terminal extends React.Component
    constructor: (props) ->
      super props
      @state =
        terminalText: ''
        commands: []
        console: []
      @jsObjs = newJsObjs(@onConsoleLog)
    handleCommandChange: (e)  =>
      @setState terminalText: e.target.value
    promptChar: =>
      if @props.javascript then ' > ' else ' $ '
    onConsoleLog: (log, type) =>
      @setState {
        commands: @state.commands.concat log: log, type: type
        console: @state.console.concat log: log, type: type
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
          try
            jsOutput = JSJS.EvaluateScript @jsObjs.cx, @jsObjs.glob, command.text
            output = JSJS.identifyConvertValue JSJS.Types.dynamicPtr, jsOutput

            if output?
              command.output = output?.toString() || typeof output

            command = @props.onJavascript command, output, @state.console, @jsObjs
          catch error
            command.error = error.toString()

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
            if command.text == 'help'
              command.response = @props.helpText
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
          if command.log
            div key: i,
              div className: 'terminal-row',
                span className: ['log', command.logType].join(' '),
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
