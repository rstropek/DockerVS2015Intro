import * as express from "express";
import * as cors from "cors";
import * as bodyParser from "body-parser";
import * as config from "./config";
import reviver from "./middleware/reviver";
import addDataContext from "./middleware/add-data-context";
import * as eventApi from "./middleware/events-api";
import * as participantsApi from "./middleware/participants-api";
import * as jwt from "express-jwt";

var app = express();

// Create express server
app.use(cors());
var bodyParserOptions = { reviver: reviver };
app.use(bodyParser.json(bodyParserOptions));

// Events API
app.get("/api/events", eventApi.getAll);
app.get("/api/events/:_id", eventApi.getById);
app.post("/api/events", eventApi.add);
app.get("/api/events/:_id/registrations", eventApi.getRegistrations);
app.post("/api/events/:_id/registrations", eventApi.addRegistration);

// Participants API
app.post("/api/participants", participantsApi.add);
app.post("/api/participants/:participantId/checkin/:eventId", participantsApi.checkIn);
app.get("/api/participants/statistics", participantsApi.getStatistics);
app.get("/api/participants/statistics/gender", participantsApi.getGenderStatistics);

// Start express server
var port: any = process.env.port || 1337;
addDataContext(config.MONGO_URL, app, () => {
    app.listen(port, () => {
        console.log(`Server is listening on port ${port}`);
    });
});