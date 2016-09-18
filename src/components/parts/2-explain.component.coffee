React = require 'react'

{div, h3, h4, p, span, input, table, thead, tbody, tr, td, th, small, div} = r = React.DOM
e = React.createElement

module.exports =
  class Part2Explain extends React.Component
    @number = 1
    @placeholder = 'type `node` to start the Javascript emulator.'
    @helpText = 'Type `node` to start the Javascript emulator.'
    onCommand: (command) =>
      if command.split(' ')[0] == 'node'
        @props.onDone()
        'Starting node...'
    render: ->
      div className: 'stage-2-explain',
        p null, """
                You go to your terminal, and type in `support`. Suddenly, this
                text appears. You get another message on the screen. It reads,
                "Great! Thanks for the help. I was trying to finish this guide
                on how to program for my LA class (we have a project called
                Writer's Workshop), but my computer started glitching. Then, my
                computer started sending out bright beams of light. Infact, they
                were so bright, I couldn't see the screen. So, of course,
                out of curiosity, I reached out to touch the screen. I'm not
                sure what I was thinking at the time, but it turned out to be a
                really bad idea to touch a screan with crazy beams of light
                coming out of it; I was transported inside of this paper, and
                there is no way for me to get out without help. That's where you
                come in: I need you to help get me out of this mess by writing
                some code. I'll try to support you every step of the way. I'm
                afraid that I only have a limited amount of time, as I don't
                want that odd glitch to somehow kill me. Plus, it'd be great to
                be out by the end of Thursday, so that I can turn in my paper
                without getting a late penalty. That sound good?"
                """
        p null, """
                You respond with a yes. It can't be that hard to fix the paper,
                can it?
                """
        p null, """
                Another message appears, "Ok great! Let's get started. We're
                going to use a programming language called Javascript to fix the
                paper, as it's currently the only language that works on the
                web. Don't worry though, it's pretty simple to learn. I managed
                to install a Bash emulator onto this page (like Terminal on a
                Mac, or Command Prompt on a Windows PC). Also, I've installed a
                mock version of node.js, a Javascript Environment onto the
                emulator. A Javascript Environment allows you to run code
                written in Javascript. You can access it by typing `node` into
                the Terminal emulator.
                """
