var MULTI_DENT = "\t";
var MULTI_DENT_LEN = MULTI_DENT.length;

var IndentLexer = {
  init: function(S){
    this.input = S;
    this.lines = [];
    this.count = 0;
    this.getLines();
  },
  getLines: function(){
    this.lines = this.input.split(/\n+/);
    this.lines.push('');
  },
  scan: function(){
    var result = [];
    for(i in this.lines){
      var l = this.scanOneLine(this.lines[i]);
      result.push(l);
    }
    return result.join('\n');
  },
  scanOneLine: function(S){
    var data = this.countIndent(S);

    e = data.count - this.count;
    this.count = data.count;
    var lineContent = S.substring(data.position, S.length);
    var fix = '';
    if(e > 0){
      for(var i = 0; i < e; i++)
        fix += '{';
      lineContent = fix + lineContent;
    }
    else if(e < 0){
      for(var i = 0; i < 0 - e; i++)
        fix += '}'
      lineContent = fix + lineContent;
    }
    return lineContent;
  },
  countIndent: function(S){
    var c = 0;
    var pos = 0;
    while(S[pos] == ' ' || S[pos] == '\n')
      pos++;
    while(pos + MULTI_DENT_LEN <= S.length && S.substr(pos, MULTI_DENT_LEN) == MULTI_DENT){
      c++;
      pos += MULTI_DENT_LEN;
    }
    return {count: c, position: pos};
  }
}


if (typeof require !== 'undefined' && typeof exports !== 'undefined') {
  exports.scanner = IndentLexer;
  exports.main = function commonjsMain(args) {
      if (!args[1]) {
          console.log('Usage: '+args[0]+' FILE');
          process.exit(1);
      }
      var source = require('fs').readFileSync(require('path').normalize(args[1]), "utf8");
      exports.scanner.init(source);
      var s = exports.scanner.scan();
      console.log(s);
      return s;
  };
  if (typeof module !== 'undefined' && require.main === module) {
    exports.main(process.argv.slice(1));
  }
}

/*
$(document).ready(function() {
  var content = $('#content').text();
  IndentLexer.init(content);
  console.log(IndentLexer.scan());
});*/