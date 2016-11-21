React = require 'react'

{div, h3, h4, p, span, input, strong, small, br, div, hr} = r = React.DOM
e = React.createElement

HelpBoxComponent = require '../help-box'

module.exports =
  class Part1Support extends React.Component
    @number = 0
    @placeholder = 'Try typing in `help` here.'
    onCommand: (command) =>
      if command.split(' ')[0] == 'help'
        @props.onDone()
        'Help infomation shown.'
    render: ->
      div className: 'stage-1-support',
        p className: 'mla',
          """
          You're looking around the web, when you stumble upon a paper. And,
          well, something feels... off. You really think that this paper is
          broken. Luckily, it's not just a stupid Word document, it's a
          website. Maybe this will be an opertunity for you to learn to code.
          You notice a terminal below this text, and you know enough from your
          days of running a Minecraft server to know that you can normally pull
          up some help infomation in a terminal by typing in the `help` command.
          So umm... yeah. You try that.
          """
        e HelpBoxComponent, hidden: !@props.current, title: 'Hey!',
          p null,
            """
            I'm a note. I'll be here every once in a while to give you some
            seemingly (hopefully) helpful help. Anyways, this paper is
            interactive, """
            span className: 'screen-hidden', """
              at least when viewed on a computer. You can go to
              BenSites.com/FixThisPaper
            """
            " so you can actually use the terminal below. Pretty cool, right?"
            span className: 'print-hidden', ' Try it out:'
