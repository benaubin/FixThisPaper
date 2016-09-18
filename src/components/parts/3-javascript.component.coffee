React = require 'react'

{div, p, span, div, a} = r = React.DOM
e = React.createElement

module.exports =
  class Part3Javascript extends React.Component
    @number = 2
    @placeholder = 'Tell Troy what your name is...'
    onJavascript: (command, output, console, jsObjs) =>
      if output?
        command.output = output?.toString() || typeof output
      try
        ntype = JSJS.identifyConvertValue JSJS.Types.dynamicPtr,
          JSJS.EvaluateScript jsObjs.cx, jsObjs.glob, "typeof name"

        if ntype == 'undefined'
          command.error = if command.error
            "#{command.error || ''} Name wasn't set."
          else
            "Name wasn't set."
        else
          name = JSJS.identifyConvertValue JSJS.Types.dynamicPtr,
            JSJS.EvaluateScript jsObjs.cx, jsObjs.glob, "name"

          if name? && ntype == 'string'
            @props.onName name
            command.response = "Set name to #{name}"
          else
            command.error = "#{name} doesn't look like a name."

      catch error
        command.error = "Couldn't get name: #{error}."
        console.warn('Caught error while getting name', error)
      command
    render: ->
      div className: 'stage-3-javascript',
        p null, """
                You type in node, and now, this message also appears.

                Ok. Great. Thanks for helping me. I just released, I
                completely forgot to introduce myself. My name is Troy. What is
                your name?
                """
        p null,
          """
          It looks like your best bet is to set the variable `name` to
          your name, but you aren't quiet sure how to do this. You """
          a href: 'http://lmgtfy.com/?q=variable+javascript', target: '_blank',
            """
            Google 'variable javascript'
            """
          " to try to get an idea of what to do."
