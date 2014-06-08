// index.js
var coffeeparser = parser;
var QScode = $("#coffee-text").text();
var BScode = $("#coffee-BS-text").text();
function exec (input) {
	IndentLexer.init(input);
	var s = IndentLexer.scan();
    return format(addDeclare(coffeeparser.parse(s)));
};
changetoBS = function() {
	$("#coffee-text").text(BScode);
};

changetoQS = function() {
	$("#coffee-text").text(QScode);
}