import * as express from "express";
import * as contracts from "../dataAccess/contracts";
import * as model from "../model";
import getDataContext from "./get-data-context";

export async function getById(req: express.Request, res: express.Response, next: express.NextFunction) {
    try {
        // Query db
        var store = getDataContext(req).participants;
        var result = await store.getById(req.params._id);

        // Build result
        if (result) {
            res.status(200).send(result);
        } else {
            // Not found
            res.status(404).end();
        }
    } catch (err) {
        res.status(500).send({ error: err });
    }
}

export async function add(req: express.Request, res: express.Response, next: express.NextFunction) {
    try {
        // Check validity of passed event
        let participant: model.IParticipant = req.body;
        let validationResult = model.isValidParticipant(participant, true);
        if (!validationResult.isValid) {
            // Bad request
            res.status(400).send(validationResult.errorMessage);
        }

        // Add row to db
        let store = getDataContext(req).participants;
        let result = await store.add(participant);

        // Build result
        res.setHeader("Location", `/api/participants/${result._id}`);
        res.status(201).send(result);
    } catch (err) {
        res.status(500).send({ error: err });
    }
}

export async function checkIn(req: express.Request, res: express.Response, next: express.NextFunction) {
    try {
        let dc = getDataContext(req);

        let event = await dc.events.getById(req.params.eventId);
        if (!event) {
            res.status(404).send("Unknown event");
            return;
        }

        let participant = await dc.participants.getById(req.params.participantId);
        if (!participant) {
            res.status(404).send("Unknown participant");
            return;
        }

        var newCheckin = await dc.registrations.checkIn(event, participant);
        res.status(200).send({
            newCheckin: newCheckin,
            givenName: participant.givenName,
            numberOfCheckins: await dc.registrations.getNumberOfCheckins(participant._id)
        });
    } catch (err) {
        res.status(500).send({ error: err });
    }
}

export async function getStatistics(req: express.Request, res: express.Response, next: express.NextFunction) {
    try {
        let dc = getDataContext(req);
        let checkinLimit = 0;
        if (req.query.checkinLimit) {
            checkinLimit = parseInt(req.query.checkinLimit);
            if (isNaN(checkinLimit)) {
                checkinLimit = 0;
            }
        }

        let rawResults = await dc.registrations.getStatistics(checkinLimit);
        let results: model.IParticipantStatistics[] = [];
        for (let row of rawResults) {
            var participant = await dc.participants.getById(row._id.toHexString());
            results.push({
                _id: participant._id,
                givenName: participant.givenName,
                familyName: participant.familyName,
                email: participant.email,
                totalNumberOfCheckins: row.totalNumberOfCheckins
            });
        }

        res.status(200).send(results);
    } catch (err) {
        res.status(500).send({ error: err });
    }
}

export async function getGenderStatistics(req: express.Request, res: express.Response, next: express.NextFunction) {
    try {
        let dc = getDataContext(req);
        let results = await dc.registrations.getGenderStatistics();
        res.status(200).send(results);
    } catch (err) {
        res.status(500).send({ error: err });
    }
}