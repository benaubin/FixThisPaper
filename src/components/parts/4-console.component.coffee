React = require 'react'
Lunicode = require 'exports?Lunicode!../../../vendor/lunicode'

luni = new Lunicode()

luni.tools.creepify.options.maxHeight = 4
luni.tools.creepify.options.randomization = 2

randomlyCreepifyText = (chance, text, details) ->
  count = 0
  creepifiedText = Array.from(text).map (char) ->
    if chance > Math.random()
      count++
      luni.tools.creepify.encode(char)
    else
      char
  .join('')
  if details
    {
      text: creepifiedText
      creepyCount: count
      original: text
      originalLength: text.length
      percentCreepy: count / text.length
    }
  else
    creepifiedText


{div, p, span, div, a} = r = React.DOM
e = React.createElement

module.exports =
  class Part4Console extends React.Component
    @number = 3
    @placeholder = 'Do some math!'
    onJavascript: (command, output, console, jsObjs) =>
      if output? && Number(output) != NaN
        answerPercent = Math.round(Number(output) * 1000)
        creepyPercent = Math.round(@creepyText.percentCreepy * 1000)
        if answerPercent == creepyPercent
          command.response = "That's correct!"
        else
          command.error = "Are you sure?"
      else
        command.error = "Last time I checked, you can't do math on #{output}."
      command
    render: ->
      @creepyText = randomlyCreepifyText 0.03, """
        You entered in your name. Again, more text popped up. Troy wrote
        another messsage, "Hello, #{@props.name || 'user'}! It's awesome
        that you already know how to use variables in Javascript! I was
        thinking that I was going to have to instruct you on how to do
        that. Speaking of things I don't have to tell you, I think we've
        found the glitch. I noticed it a bit futher down the paper, but it
        must be spreading. Hopefully it's nothing to worry about... I just
        hope that it doesn't get stronger, or it will be hard to communicate
        with you. Maybe it is... could you do me a huge favor? Javascript
        should allow you to use math to figure out about how many of these
        characters have been consumed by the glitch. I can't see what you're
        seeing, so it would be very useful if you do that."
        """, true
      div className: 'stage-4-console',
        p null, @creepyText.text
        p null,
          randomlyCreepifyText 0.03,"""
            You count up the letters. Your numbers show that about
            #{@creepyText.creepyCount} of the #{@creepyText.originalLength}
            letters have been consumed by the glitch. You do a bit of Googling,
            and find """
          a href: 'https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Arithmetic_Operators',
            randomlyCreepifyText 0.03, 'this article'
          randomlyCreepifyText 0.03, " about arithmetic in Javascript."
