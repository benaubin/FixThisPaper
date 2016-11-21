React = require 'react'
randomlyCreepifyText = require '../../helpers/creepify-text'

{div, p, span, div, a} = r = React.DOM
e = React.createElement

module.exports =
  class Part5Console extends React.Component
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
      commandI
    render: ->
      div className: 'stage-4-console',
        p className: 'mla', randomlyCreepifyText 0.04, """
          "
          Your math seemed to add up. Another message appears, "Hey
          #{@props.name}, thanks for doing that math. Ok. No need to worry for
          now.
          Anyways, I want to teach you one more thing: how to use the console.
          Basically, the console allows you to
          "
          """, true
        p className: 'mla',
          randomlyCreepifyText 0.03,"""
            You count up the letters. Your numbers show that about
            #{@creepyText.creepyCount} of the #{@creepyText.originalLength}
            letters have been consumed by the glitch. You do a bit of Googling,
            and find """
          a href: 'https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Arithmetic_Operators',
            randomlyCreepifyText 0.03, 'this article'
          randomlyCreepifyText 0.03, " about arithmetic in Javascript."
