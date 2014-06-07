// index.js
var coffeeparser = parser;

function exec (input) {
	IndentLexer.init(input);
	var s = IndentLexer.scan();
    return coffeeparser.parse(s);
}
