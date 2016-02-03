var needle = require('needle');
console.log("Requesting data from dependent-service:1337");
needle.get("http://dependent-service:1337/customers", function(err, resp, body) {
	console.log(body);
});
