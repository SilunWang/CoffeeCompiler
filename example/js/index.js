// index.js
var coffeeparser = parser;
var QScode = $("#coffee-text").val();
var BScode = $("#coffee-BS-text").val();

function exec (input) {
	IndentLexer.init(input);
	var s = IndentLexer.scan();
    return format(addDeclare(coffeeparser.parse(s)));
};

function changetoBS() {
	$("#coffee-text").val(BScode);
};

function changetoQS() {
	$("#coffee-text").val(QScode);
};

function compile () {
	try{
		var result = exec($("#coffee-text").val());		
	}
	catch(err){
		alert(err);
	}
	$("#js-text").text(result);
	var value = eval(result);
	$("#twitter").html("RESULT: " + value);
};