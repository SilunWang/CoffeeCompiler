// 请当做函数来使用
// 实际的入口在末尾
function addDeclare(src) {

	var keyWordsList = [
		'function', 
		'if', 
		'else',
		'for',
		'while',
		'true',
		'false',
		'undefined',
		'null',
		'this',
		'in'
	];

	var variableRegex = /^[a-zA-Z_][a-zA-Z0-9_]*/;
	var objRegex = /^[a-zA-Z_][a-zA-Z0-9_]*\.[a-zA-Z_][a-zA-Z0-9_]*/;

	var existsAll = [];

	var existsFrame = [];

	function process (src) {
		var dest = "";
		while (src != "") {
			if (src[0] == '{') {
				existsAll.push(existsFrame);
				existsFrame = [];
			}
			if (src[0] == '}') {
				existsFrame = existsAll.pop();
			}
			var str = variableRegex.exec(src);
			var strobj = objRegex.exec(src);
			if (str != null && str.length != 0 && (strobj == null || strobj.length == 0)) {
				str = str[0];
				src = src.substr(str.length, src.length - str.length);
				var ch = getNextChar(src);
				// 满足声明要求
				if (!isKeyWords(str) && !isExists(str) && ch == '=') {
					// 这个位置适合加声明语句
					if (dest == "" || dest[dest.length - 1] == '\n') {
						dest = dest + 'var ' + str + ';\n';
					}
					// 这个位置不适合加声明语句
					else {
						var pos = dest.length - 1;
						for (; pos >= 0; pos--) {
							if (dest[pos] == '\n') {
								break;
							}
						}
						dest = dest.substr(0, pos+1) + ('var ' + str + ';\n') + dest.substr(pos+1, dest.length-pos-1);
					}
					existsFrame.push(str);
				}
				dest = dest + str;
			}
			else if (strobj != null && strobj.length != 0) {
				strobj = strobj[0];
				src = src.substr(strobj.length, src.length - strobj.length);
				dest = dest + strobj;
			}
			else {
				dest = dest + src[0];
				src = src.substr(1, src.length - 1);
			}
		}
		return dest;
	}

	function isKeyWords (word) {
		for (var i = 0; i < keyWordsList.length; i++) {
			if (word == keyWordsList[i]) {
				return true;
			}
		}
		return false;
	}

	function isExists (word) {
		for (var i = 0; i < existsAll.length; i++) {
			for (var j = 0; j < existsAll[i].length; j++) {
				if (word == existsAll[i][j]) {
					return true;
				}
			}
		}
		for (var i = 0; i < existsFrame.length; i++) {
			if (word == existsFrame[i]) {
				return true;
			}
		}
		return false;
	}

	function getNextChar(str) {
		for (var i = 0; i < str.length; i++) {
			if (str[i] != ' ') {
				return str[i];
			}
		}
		return '\0';
	}

	return process(src);

};