import { IEventbriteEventStatus } from '../dataAccess/contracts';
import * as express from "express";
import * as contracts from "../dataAccess/contracts";
import * as model from "../model";
import getDataContext from "./get-data-context";
import * as config from '../config';

export async function getAll(req: express.Request, res: express.Response, next: express.NextFunction) {
    try {
        const includePastEvents = req.query.past && req.query.past === "true";
        const includeTicketClassStatus = req.query.tcStatus && req.query.tcStatus === "true";

        // Query db
        const dc = getDataContext(req);
        let result = await dc.events.getAll(includePastEvents);

        if (includeTicketClassStatus) {
            const statuses = await dc.eventbrite.getTicketClassStatuses(result.map(e => e.eventbriteId));
            result.forEach(e => {
                const status = statuses.filter(s => s.eventId == e.eventbriteId)[0];
                e.quantitySold = status.quantitySold;
                e.quantityTotal = status.quantityTotal;
            });
        }

        // Build result
        res.status(200).send(result);
    } catch (err) {
        res.status(500).send({ error: err });
    }
}

export async function getById(req: express.Request, res: express.Response, next: express.NextFunction) {
    try {
        // Query db
        let store = getDataContext(req).events;
        let result = await store.getById(req.params._id);

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
        let event: model.IEvent = req.body;
        let validationResult = model.isValidEvent(event, true);
        if (!validationResult.isValid) {
            // Bad request
            res.status(400).send(validationResult.errorMessage);
        }

        // Add row to db
        let store = getDataContext(req).events;
        let result = await store.add(event);

        // Build result
        res.setHeader("Location", `/api/events/${result._id}`);
        res.status(201).send(result);
    } catch (err) {
        res.status(500).send({ error: err });
    }
}

export async function getRegistrations(req: express.Request, res: express.Response, next: express.NextFunction) {
    try {
        let includeStatistics = req.query.stats && req.query.stats === "true";

        let dc = getDataContext(req);
        let result = await dc.registrations.getByEventId(req.params._id, includeStatistics);
        if (!result || result.length == 0) {
            result = [];
        }

        return res.status(200).send(result);
    } catch (err) {
        res.status(500).send({ error: err });
    }
}

export async function addRegistration(req: express.Request, res: express.Response, next: express.NextFunction) {
    try {
        let dc = getDataContext(req);

        // Load event based on event ID
        let event = await dc.events.getById(req.params._id);
        if (!event) {
            // Not found
            res.status(404).end();
            return;
        }

        // Make sure participant is there 
        if (!req.body.participant) {
            // Bad request
            res.status(400).send({ message: "Missing member 'participant'" });
            return;
        }

        // Check if participant is valid
        let participant: model.IParticipant = req.body.participant;
        let validation = model.isValidParticipant(participant, true);
        if (!validation.isValid) {
            // Bad request
            res.status(400).send({ message: validation.errorMessage });
            return;
        }

        // Upsert participant
        participant = await dc.participants.upsertByName(participant);

        // Upsert registration
        let registration = await dc.registrations.upsertByEventAndParticipant({
            event: { id: event._id, date: event.date },
            participant: { id: participant._id, givenName: participant.givenName, familyName: participant.familyName },
            registered: true,
            needsComputer: req.body.needsComputer
        });

        // Check participant in
        if (req.body.checkedin) {
            await dc.registrations.checkIn(event, participant);
        }

        return res.status(201).end();
    } catch (err) {
        res.status(500).send({ error: err });
    }
}