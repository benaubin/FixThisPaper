React = require 'react'

{div, h3, h4, p, span, input, strong, small, br, small, div, ul, li} = r = React.DOM
e = React.createElement

HelpBoxComponent = require '../help-box'
GlitchTextComponent = require '../glitch-text'

module.exports =
  class Part2Explain extends React.Component
    constructor: (props) ->
      super props
      @state =
        watched: false
    @number = 1
    @placeholder = 'you try typing `node` to run some javascript.'
    @helpText = 'Type `node` to start the Javascript emulator.'
    componentDidMount: ->
      unless @state.watched
        scrollListener = =>
          el = window.document.getElementById('watched-paragraph')
          top = el.offsetTop
          height = el.offsetHeight

          top += el.offsetTop while el = el.offsetParent

          if top < window.pageYOffset + (window.innerHeight / 5 * 3)
            window.setTimeout =>
              window.document.body.classList.add('watched-1')
              window.setTimeout =>
                window.document.body.classList.remove('watched-1')
                window.document.body.classList.add('watched-1-after')
                window.setTimeout =>
                  @setState watched: true
                , 1000
              , 4 * 1000
            , 10 * 1000
            document.removeEventListener 'scroll', scrollListener
        document.addEventListener 'scroll', scrollListener
    onCommand: (command) =>
      if command.split(' ')[0] == 'node'
        @props.onDone()
        'Starting node...'
    render: ->
      div className: 'stage-2-explain',
        e HelpBoxComponent, title: "Paper #{@props.version} Help Infomation:",
          p null, """
          Designed for the authors's LA Class. Designed to teach code in an...
          'interesting' way. Not ready for use.
          """
          strong null, 'Commands:'
          ul null,
            li null,
              strong null, 'node'
              ': start a Javascript emulator'
          strong null, "Known Bugs:"
          ul null,
            li null, 'Very glitchy'
            li null, 'Dangerously glitchy'
        p className: 'mla', id: 'watched-paragraph', """
          An "interesting" way? You stop for a bit to wonder what the author
          meant by that. It seems to concern you. Only a bit. What really
          concerns you is the "dangerously" glitchy known-bug. Maybe your hunch
          about this paper was right. It just feels, weird. Like you're being
          watched cloesly. Almost as if someone cares about what you do in your
          free time. The thought makes you laugh a bit. And even while it feels
          so ridiculous, you can't shake that feeling that you're being watched.
          You're being watched, somehow, you just know.
          """
        e GlitchTextComponent,
          className: 'mla'
          stopGlitch: !@state.watched
          text: """
          You know someone's watching you. It's creepy. The hairs on your neck
          are standing. You look behind you, but there's nothing there.
          Something, someone, they are watching. They have to be. It's what
          seems like a meaningless fear. You've been on websites that felt
          creepy before, but you knew everything was still fine. Still, this
          one seems somewhat.... dangerous. You feel unsafe. You have this
          strong feeling that someone or something, they have to be watching.
          """
        div className: !@state.watched && 'screen-hidden',
          div className: 'eye screen-hidden'
          e GlitchTextComponent, className: 'mla', text: """
          "Wait? What was that?" you ask, but no one's there. The eye
          disappeared faster then it appeared. Your suspicion must have been
          right. Something's wrong. Maybe someone hacked into your computer.
          Looks like you'll have to hurry in order to get this fixed. How could
          you fix it? You take some time to think; to figure out what to do to
          fix this crazy mess.
          """
          e GlitchTextComponent, className: 'mla', text: """
          "I got it!" you exclaim. This paper's a website - so you should be
          able to hack into it with Javascript. Maybe that will work. If only
          you could find a way to -- you remember there's a terminal on this
          page... if only there were a way to... maybe...
          """
