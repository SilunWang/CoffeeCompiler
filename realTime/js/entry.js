var IndentLexer = require('./Indent');
var addDeclare = require('./addDeclare');
var format = require('./format')
var parser = require('../../parser').parser;

if (typeof require !== 'undefined' && typeof exports !== 'undefined') {
	exports.main = function commonjsMain(args) {
	    if (!args[1]) {
		console.log('Usage: '+args[0]+' FILE');
		process.exit(1);
	    }
	    var source = require('fs').readFileSync(require('path').normalize(args[1]), "utf8");
	    IndentLexer.init(source);
	    var s = IndentLexer.scan();
	    var res = parser.parse(s);
	    res = addDeclare(res);
	    res = format(res);
	    console.log(res);
	    return res;
	};
	if (typeof module !== 'undefined' && require.main === module) {
	  exports.main(process.argv.slice(1));
	}
}

