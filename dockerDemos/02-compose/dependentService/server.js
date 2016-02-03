var express = require('express');
var bodyParser = require('body-parser');
var app = express();
var port = process.env.port || 1337;

app.use(bodyParser.json());

var customerId = 0;
var repository = [{ _id: 1, firstName: "Foo", lastName: "Bar" }];

app.get('/customers', function (req, res) {
    if (repository.length) {
        res.status(200).send(repository);
    }
    else {
        res.status(404).end();
    }
});

app.post('/customers', function (req, res) {
    var customer = req.body;
    if (customer && customer.firstName && customer.lastName) {
        var newCustomer = { _id: ++customerId, firstName: customer.firstName, lastName: customer.lastName };
        repository.push(newCustomer);
        res.setHeader("Location", "/customers/" + newCustomer._id);
        res.status(201).send(newCustomer);
    }
    else {
        res.status(400).end();
    }
});

app.get('/customers/:customerId', function (req, res) {
    var id = parseInt(req.params.customerId);
    if (isNaN(id)) {
        res.status(400).end();
    }
    else {
        var result = repository.filter(function (c, _, __) { return c._id == id; });
        if (result.length) {
            res.status(200).send(result[0]);
        }
        else {
            res.status(404).end();
        }
    }
});

var server = app.listen(port, function () {
    console.log('Listening on port %s', port);
});

