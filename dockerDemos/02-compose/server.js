const axios = require('axios').default;

console.log("Requesting data from dependent-service:1337");
(async () => {
	try {
		const resp = await axios.get("http://ds/customers");
		console.log(resp.data);
	} catch (err) {
		console.error(err);
	}
})();