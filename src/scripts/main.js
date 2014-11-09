require([ "jquery", "second" ], function($, second) {
	console.log(Math.sin(Math.PI/2));
	$('.well').append("sin( " + Math.PI + " ) = " + Math.sin(Math.PI).toFixed())
});