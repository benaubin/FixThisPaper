React = require 'react'

{div, h3, h4, p, span, input, table, thead, tbody, tr, td, th, small, div} = r = React.DOM
e = React.createElement

module.exports =
  class Part1Support extends React.Component
    @number = 0
    @placeholder = 'type `support` to help the writer of the message.'
    @helpText = 'Type `support` to help the writer of the message, then press enter.'
    onCommand: (command) =>
      if command.split(' ')[0] == 'support'
        @props.onDone()
        'You agree to help the voice.'
    render: ->
      div className: 'stage-1-support',
        p className: 'mla',
          """
          A message appears. It reads, "
          """
          r.i null, "Psst! "
          """
          Can you help me? I think I just broke this paper."
          You respond with a yes, but you aren't really sure how to help.
          Another message appears and explains that you have to run the
          `support` command in your terminal. It looks like you can use the
          terminal below.
          """
