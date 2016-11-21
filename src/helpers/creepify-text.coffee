Lunicode = require 'exports?Lunicode!../../vendor/lunicode'

luni = new Lunicode()

luni.tools.creepify.options.maxHeight = 4
luni.tools.creepify.options.randomization = 2

module.exports = (chance, text, details) ->
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
