through2 = require 'through2'


module.exports = ->
  words = 0
  lines = 1
  letterCount = 0
  byteLength = 0

  transform = (chunk, encoding, cb) ->
    lines = chunk.split('\n').filter((line) -> line.length > 0).length

    letterCount = chunk.length

    # remove blank lines
    chunk = chunk.split('\n').filter((line) -> line.length > 0).join(' ');
    chunk = chunk.replace(/([a-z])([A-Z])/g, "$1 $2")
      .replace(/"[^"]+"/gm, "word")
      .replace(/[^a-zA-Z0-9 ]/g, "");


    tokens = chunk.split(' ')
    words = tokens.length
    return cb()

  flush = (cb) ->

    this.push {words, lines, letterCount}
    this.push null
    return cb()

  return through2.obj transform, flush
