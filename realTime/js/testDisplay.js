function display(){
	$(".list").html(testList.toString());
	$(".binary-search").html(bTest.toString());
	$(".quick-sort").html(sTest.toString());
}

$(document).ready(function() {
	display();
});
