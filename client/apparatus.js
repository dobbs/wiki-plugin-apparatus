(function() {
  var bind, drawingUrl, emit, expand, parse;

  expand = function(text) {
    return text.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
  };

  parse = function(text) {
    var doc, i, len, line, ref, result, viewer, x, y;
    result = {};
    ref = text.split(/\n/);
    for (i = 0, len = ref.length; i < len; i++) {
      line = ref[i];
      if (viewer = line.match(/^VIEWER +(.+)$/)) {
        result.viewer = viewer[1];
      }
      if (doc = line.match(/^DOC +(.+)$/)) {
        result.doc = doc[1];
      }
      if (x = line.match(/^X +(-?\d+) +(-?\d+)/)) {
        result.boundsX = [parseInt(x[1]), parseInt(x[2])];
      }
      if (y = line.match(/^Y +(-?\d+) +(-?\d+)/)) {
        result.boundsY = [parseInt(y[1]), parseInt(y[2])];
      }
    }
    return result;
  };

  drawingUrl = function(spec) {
    var boundsX, boundsY, doc, ref, ref1, ref2, ref3, region, viewer;
    if (spec == null) {
      spec = {};
    }
    viewer = (ref = spec.viewer) != null ? ref : 'https://apparatus.wiki.dbbs.co/';
    doc = (ref1 = spec.doc) != null ? ref1 : 'doc/examples/Wheel+Diagram.json';
    boundsX = (ref2 = spec.boundsX) != null ? ref2 : [-4, 4];
    boundsY = (ref3 = spec.boundsY) != null ? ref3 : [-3, 3];
    region = JSON.stringify({
      x: boundsX,
      y: boundsY
    }).replace(/ +/g, '');
    return [viewer + "?load=" + doc, 'fullScreen=1', 'viewOnly=1', 'editLink=1', "regionOfInterest=" + region].join('&');
  };

  emit = function($item, item) {
    var height, spec, w2hRatio;
    spec = parse(item.text);
    w2hRatio = (spec.boundsX[1] - spec.boundsX[0]) / (spec.boundsY[1] - spec.boundsY[0]);
    height = 430 / w2hRatio;
    console.log({
      width: spec.boundsX[1] - spec.boundsX[0],
      height: spec.boundsY[1] - spec.boundsY[0],
      w2hRatio: w2hRatio
    });
    $item.append('<iframe></iframe><p></p>');
    $item.find('iframe').attr({
      width: 430,
      height: height,
      style: 'border: none;',
      src: drawingUrl(spec)
    });
    return $item.find('p').css({
      'background-color': '#eee',
      padding: '15px'
    }).text(drawingUrl(spec));
  };

  bind = function($item, item) {
    return $item.dblclick(function() {
      return wiki.textEditor($item, item);
    });
  };

  if (typeof window !== "undefined" && window !== null) {
    window.plugins.apparatus = {
      emit: emit,
      bind: bind
    };
  }

  if (typeof module !== "undefined" && module !== null) {
    module.exports = {
      parse: parse,
      drawingUrl: drawingUrl,
      expand: expand
    };
  }

}).call(this);

//# sourceMappingURL=apparatus.js.map
