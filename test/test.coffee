# build time tests for apparatus plugin
# see http://mochajs.org/

apparatus = require '../client/apparatus'
expect = require 'expect.js'

describe 'apparatus plugin', ->

  describe 'expand', ->

    it 'can make itallic', ->
      result = apparatus.expand 'hello *world*'
      expect(result).to.be 'hello <i>world</i>'
