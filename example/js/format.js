function format(src) {
	var count = 0;
	var dest = "";
	while (src != "") {
		dest = dest + src[0];
		if (src[0] == '{') {
			count++;
		}
		if (src[0] == '}') {
			count--;
		}
		if (src[0] == '\n') {
			var reallyIndent = count;
			if (src.length > 1 && src[1] == '}') {
				reallyIndent = count - 1;
			}
			for (var i = 0; i < reallyIndent; i++) {
				dest = dest + "    ";
			}
		}
		src = src.substr(1, src.length - 1);
	}
	return dest;
}
