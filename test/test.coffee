# build time tests for apparatus plugin
# see http://mochajs.org/

apparatus = require '../client/apparatus'
expect = require 'expect.js'

describe 'apparatus plugin', ->

  describe 'parse', ->
    result = {}
    text = '''
VIEWER http://aprt.us/editor/
DOC doc/examples/Wheel+Diagram.json
X -6 6
Y -3 3
'''

    beforeEach ->
      result = apparatus.parse text

    it 'finds VIEWER', ->
      expect(result).to.have.property 'viewer', 'http://aprt.us/editor/'

    it 'finds DOC', ->
      expect(result).to.have.property 'doc', 'doc/examples/Wheel+Diagram.json'

    it 'finds X', ->
      expect(result).to.have.property 'boundsX'
      expect(result.boundsX).to.eql [-6, 6]

    it 'finds Y', ->
      expect(result).to.have.property 'boundsY'
      expect(result.boundsY).to.eql [-3, 3]

  describe 'drawingUrl', ->

    result = ''

    beforeEach ->
      result = apparatus.drawingUrl(
        viewer: 'https://example.com/'
        doc: 'doc/foo'
        boundsX: [-2, 2]
        boundsY: [-1, 1]
      )

    it 'starts with the viewer as base url', ->
      expect(result).to.match /^https:\/\/example.com/

    it 'loads the doc', ->
      expect(result).to.match /load=doc\/foo/

    it 'sets fullScreen', ->
      expect(result).to.match /fullScreen=1/

    it 'sets viewOnly', ->
      expect(result).to.match /viewOnly=1/

    it 'sets editLink', ->
      expect(result).to.match /editLink=1/

    it 'includes boundsX in regionOfInterest', ->
      expect(result).to.match /regionOfInterest.*"x":\[-2,2\]/

    it 'includes boundsY in regionOfInterest', ->
      expect(result).to.match /regionOfInterest.*"y":\[-1,1\]/

    it 'formats the whole URL', ->
      console.log(result)
      expect(result).to.eql 'https://example.com/?load=doc/foo&fullScreen=1&viewOnly=1&editLink=1&regionOfInterest={"x":[-2,2],"y":[-1,1]}'

  describe 'drawingUrl with defaults', ->

    result = ''

    beforeEach ->
      result = apparatus.drawingUrl()

    it 'starts with apparatus.wiki.dbbs.co', ->
      expect(result).to.match /^https:\/\/apparatus.wiki.dbbs.co\//

    it 'loads the Wheel+Diagram.json', ->
      expect(result).to.match /load=doc\/examples\/Wheel\+Diagram.json/

    it 'boundsX -4, 4', ->
      expect(result).to.match /regionOfInterest.*"x":\[-4,4\]/

    it 'boundsY -3, 3', ->
      expect(result).to.match /regionOfInterest.*"y":\[-3,3\]/
