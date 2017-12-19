expand = (text)->
  text
    .replace /&/g, '&amp;'
    .replace /</g, '&lt;'
    .replace />/g, '&gt;'

parse = (text) ->
  result = {}
  for line in text.split /\n/
    if viewer = line.match /^VIEWER +(.+)$/
      result.viewer = viewer[1]
    if doc = line.match /^DOC +(.+)$/
      result.doc = doc[1]
    if x = line.match /^X +(-?\d+) +(-?\d+)/
      result.boundsX = [
        parseInt(x[1])
        parseInt(x[2])
      ]
    if y = line.match /^Y +(-?\d+) +(-?\d+)/
      result.boundsY = [
        parseInt(y[1])
        parseInt(y[2])
      ]
  result

drawingUrl = (spec) ->
  spec ?= {}
  viewer = spec.viewer ? 'https://apparatus.wiki.dbbs.co/'
  doc = spec.doc ? 'doc/examples/Wheel+Diagram.json'
  boundsX = spec.boundsX ? [-4, 4]
  boundsY = spec.boundsY ? [-3, 3]
  region=JSON.stringify({x: boundsX, y: boundsY}).replace(/ +/g, '')
  [
    "#{viewer}?load=#{doc}"
    'fullScreen=1'
    'viewOnly=1'
    'editLink=1'
    "regionOfInterest=#{region}"
  ].join('&')

emit = ($item, item) ->
  spec = parse item.text
  w2hRatio = (spec.boundsX[1]-spec.boundsX[0]) / (spec.boundsY[1]-spec.boundsY[0])
  height = 430 / w2hRatio
  console.log({
    width: (spec.boundsX[1] - spec.boundsX[0] )
    height: (spec.boundsY[1] - spec.boundsY[0] )
    w2hRatio: w2hRatio
  })
  $item.append '<iframe></iframe><p></p>'
  $item.find('iframe').attr(
    width: 430
    height: height
    style: 'border: none;'
    src: drawingUrl spec
  )
  $item.find('p')
    .css({'background-color': '#eee', padding: '15px'})
    .text(drawingUrl spec)

bind = ($item, item) ->
  $item.dblclick -> wiki.textEditor $item, item

window.plugins.apparatus = {emit, bind} if window?
module.exports = {parse, drawingUrl, expand} if module?
