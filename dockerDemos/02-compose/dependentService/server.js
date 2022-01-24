const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors')
const http = require('http')
const { createTerminus } = require('@godaddy/terminus')
const winston = require('winston')
const expressWinston = require('express-winston');

const app = express();
const port = process.env.PORT || 1337;

app.use(cors());
app.use(bodyParser.json());
app.use(expressWinston.logger({
    transports: [
        new winston.transports.Console()
    ],
    format: winston.format.combine(
        winston.format.colorize(),
        winston.format.simple()
    ),
}));

let customerId = 1;
const repository = [{ _id: 1, firstName: "Foo", lastName: "Bar" }];

app.get('/customers', (req, res) => {
    if (repository.length) {
        res.status(200).send(repository);
    }
    else {
        res.status(404).end();
    }
});

app.post('/customers', (req, res) => {
    const customer = req.body;
    if (customer && customer.firstName && customer.lastName) {
        const newCustomer = { _id: ++customerId, firstName: customer.firstName, lastName: customer.lastName };
        repository.push(newCustomer);
        res.setHeader("Location", "/customers/" + newCustomer._id);
        res.status(201).send(newCustomer);
    }
    else {
        res.status(400).end();
    }
});

app.get('/customers/:customerId', (req, res) => {
    const id = parseInt(req.params.customerId);
    if (isNaN(id)) {
        res.status(400).end();
    }
    else {
        const result = repository.filter(c => c._id == id);
        if (result.length) {
            res.status(200).send(result[0]);
        }
        else {
            res.status(404).end();
        }
    }
});

function onSignal() {
    console.log('Goodbye');
}

const server = http.createServer(app);

createTerminus(server, {
    signal: 'SIGINT',
    onSignal
});

server.listen(port);
