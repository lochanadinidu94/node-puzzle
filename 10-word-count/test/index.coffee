assert = require 'assert'
fs = require 'fs'
WordCount = require '../lib'


helper = (input, expected, done) ->
  pass = false
  counter = new WordCount()

  counter.on 'readable', ->
    return unless result = this.read()
    assert.deepEqual result, expected
    assert !pass, 'Are you sure everything works as expected?'
    pass = true

  counter.on 'end', ->
    if pass then return done()
    done new Error 'Looks like transform fn does not work'

  counter.write input
  counter.end()


describe '10-word-count', ->
  it 'should count a single word', (done) ->
    input = 'test'
    expected = words: 1, lines: 1, letterCount: 4
    helper input, expected, done

  it 'should count words in a phrase', (done) ->
    input = 'this is a basic test'
    expected = words: 5, lines: 1, letterCount: 20
    helper input, expected, done

  it 'should count quoted characters as a single word', (done) ->
    input = '"this is one word!"'
    expected = words: 1, lines: 1, letterCount: 19
    helper input, expected, done

  describe 'should count words as per fixtures', ->
    it '1,9,44.txt', (done) ->
      input = fs.readFileSync('./test/fixtures/1,9,44.txt', 'utf8');
      expected =
        words: 9, lines: 1, letterCount: 44
      helper input, expected, done

    it '3,7,46.txt', (done) ->
      input = fs.readFileSync('./test/fixtures/3,7,46.txt', 'utf8');
      expected = words: 7, lines: 3, letterCount: 46
      helper input, expected, done

    it '5,9,40.txt', (done) ->
      input = fs.readFileSync('./test/fixtures/5,9,40.txt', 'utf8');
      expected =
        words: 9, lines: 5, letterCount: 40
      helper input, expected, done

    it '7,13,91.txt -> multiple blank lines', (done) ->
      input = fs.readFileSync('./test/fixtures/7,13,91.txt', 'utf8');
      expected =
        words: 13, lines: 7, letterCount: 91
      helper input, expected, done
  