import { ObjectID } from 'mongodb';

/**
 * Represents a MongoDB object with an ID
 */
export interface IMongoObject {
    _id?: ObjectID;
}

export interface IValidationResult {
    isValid: boolean;
    errorMessage?: string;
}

/**
 * Checks whether an object is valid.
 * @param o - Object to validate
 * @param isNew - Indicates whether the object is a new object (_id can be empty)
 *                or an existing one (_id cannot be empty).
 */
export function isValidMongoObject(o: IMongoObject, isNew: boolean): IValidationResult {
    if (!isNew) {
        if (!o._id) {
            return { isValid: false, errorMessage: "Mandatory member '_id' is missing. Can only be left out for new objects." };
        }

        if (!(o._id instanceof ObjectID)) {
            return { isValid: false, errorMessage: "'_id' is not of type 'ObjectID'." };
        }
    }

    return { isValid: true };
}

export interface IEvent extends IMongoObject {
    date: Date;
    location: string;
    eventbriteId?: string;
    quantitySold?: number;
    quantityTotal?: number;    
}

export function isValidEvent(event: IEvent, isNew: boolean): IValidationResult {
    var result = isValidMongoObject(event, isNew);
    if (!result.isValid) {
        return result;
    }

    if (!event) {
        return { isValid: false, errorMessage: "'event' must not be null." };
    }

    if (!event.date) {
        return { isValid: false, errorMessage: "Mandatory member 'date' is missing." };
    }

    if (!(event.date instanceof Date)) {
        return { isValid: false, errorMessage: "'date' is not of type 'Date'." };
    }

    if (!event.location) {
        return { isValid: false, errorMessage: "Mandatory member 'location' is missing." };
    }

    if (typeof event.location !== "string") {
        return { isValid: false, errorMessage: "'location' is not of type 'string'." };
    }

    if (event.eventbriteId && typeof event.eventbriteId !== "string") {
        return { isValid: false, errorMessage: "'eventbriteId' is not of type 'string'." };
    }

    return { isValid: true };
}

export interface IParticipantRoles {
    isAdmin?: boolean;
}

export interface IParticipant extends IMongoObject {
    givenName?: string;
    familyName?: string;
    email?: string;
    googleSubject?: string;
    eventbriteId?: string;
    roles?: IParticipantRoles;
    yearOfBirth?: string;
    gender?: string;
}

export interface IParticipantStatistics extends IMongoObject {
    givenName?: string;
    familyName?: string;
    email?: string;
    totalNumberOfCheckins: number;
}

export function isValidParticipant(participant: IParticipant, isNew: boolean): IValidationResult {
    var result = isValidMongoObject(participant, isNew);
    if (!result.isValid) {
        return result;
    }

    if (!participant.givenName) {
        return { isValid: false, errorMessage: "Mandatory member 'givenName' is missing." };
    }

    if (typeof participant.givenName !== "string") {
        return { isValid: false, errorMessage: "'givenName' is not of type 'string'." };
    }

    if (!participant.familyName) {
        return { isValid: false, errorMessage: "Mandatory member 'familyName' is missing." };
    }

    if (typeof participant.familyName !== "string") {
        return { isValid: false, errorMessage: "'familyName' is not of type 'string'." };
    }

    if (participant.googleSubject && typeof participant.googleSubject !== "string") {
        return { isValid: false, errorMessage: "'googleSubject' is not of type 'string'." };
    }

    if (participant.eventbriteId && typeof participant.eventbriteId !== "string") {
        return { isValid: false, errorMessage: "'eventbriteId' is not of type 'string'." };
    }

    if (participant.roles) {
        if (typeof participant.roles !== "object") {
            return { isValid: false, errorMessage: "'roles' is not of type 'object'." };
        }

        if (participant.roles.isAdmin && typeof participant.roles.isAdmin !== "boolean") {
            return { isValid: false, errorMessage: "'roles.isAdmin' is not of type 'boolean'." };
        }
    }

    return { isValid: true };
}

export interface IRegistrationEvent {
    id: ObjectID;
    date: Date;
}

export interface IRegistrationParticipant {
    id: ObjectID;
    givenName: string;
    familyName: string;
}

export interface IRegistration extends IMongoObject {
    event: IRegistrationEvent;
    participant: IRegistrationParticipant;
    registered?: boolean;
    checkedin?: boolean;
    needsComputer?: boolean;
    totalNumberOfCheckins?: number;
}

export function isValidRegistration(registration: IRegistration, isNew: boolean): IValidationResult {
    var result = isValidMongoObject(registration, isNew);
    if (!result.isValid) {
        return result;
    }

    if (!registration.event) {
        return { isValid: false, errorMessage: "Mandatory member 'event' is missing." };
    }
    
    if (!registration.event.id) {
        return { isValid: false, errorMessage: "Mandatory member 'event.id' is missing." };
    }

    if (!(registration.event.id instanceof ObjectID)) {
        return { isValid: false, errorMessage: "'event.id' is not of type 'ObjectID'." };
    }

    if (!registration.participant) {
        return { isValid: false, errorMessage: "Mandatory member 'participant' is missing." };
    }

    if (!registration.participant.id) {
        return { isValid: false, errorMessage: "Mandatory member 'participant.id' is missing." };
    }

    if (!(registration.participant.id instanceof ObjectID)) {
        return { isValid: false, errorMessage: "'participant.id' is not of type 'ObjectID'." };
    }
    
    return { isValid: true };
}

export interface IClientApp extends IMongoObject {
    apiKey: string;
    clientDescription: string;
}
