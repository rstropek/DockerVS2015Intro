import * as mongodb from 'mongodb';
import * as model from '../model';

export interface IDataContext {
    db: mongodb.Db;
    events: IEventStore;
    participants: IParticipantStore;
    registrations: IRegistrationStore;
    eventbrite: IEventbrite;
    clients: IClientStore;
}

export interface IInitialAdmin {
    givenName: string;
    familyName: string;
    email: string;
    googleSubject: string;
}

export interface IStoreBase<T> {
    collection: mongodb.Collection;
    getById(_id: string): Promise<T>;
}

export interface IEventStore extends IStoreBase<model.IEvent> {
    getAll(includePastEvents: boolean): Promise<model.IEvent[]>;
    getById(_id: string): Promise<model.IEvent>;
    add(event: model.IEvent): Promise<model.IEvent>;
    upsertByEventbriteId(event: model.IEvent): Promise<model.IEvent>;
}

export interface IParticipantStore extends IStoreBase<model.IParticipant> {
    add(participant: model.IParticipant): Promise<model.IParticipant>;
    getById(_id: string): Promise<model.IParticipant>;
    getByName(givenName: string, familyName: string): Promise<model.IParticipant>;
    upsertByName(participant: model.IParticipant): Promise<model.IParticipant>;
}

export interface IRegistrationStatistics {
    _id: mongodb.ObjectID;
    totalNumberOfCheckins: number;
}

export interface IRegistrationStore extends IStoreBase<model.IRegistration> {
    checkIn(event: model.IEvent, participant: model.IParticipant): Promise<any>;
    getByEventId(eventId: string, includeStatistics?: boolean): Promise<model.IRegistration[]>;
    upsertByEventAndParticipant(registration: model.IRegistration): Promise<model.IParticipant>;
    getNumberOfCheckins(participantId: mongodb.ObjectID) : Promise<number>;
    getTotalNumberOfCheckins() : Promise<ITotalRegistrations[]>;
    getStatistics(checkinLimit?: number): Promise<IRegistrationStatistics[]>;
    getGenderStatistics(): Promise<IGenderStatistics[]>;
}

export interface IClientStore extends IStoreBase<model.IClientApp> {
    getByApiKey(apiKey: string): Promise<model.IClientApp>;
}

export interface ITotalRegistrations {
    _id: mongodb.ObjectID,
    totalNumberOfCheckins: number;
}

export interface IGenderStatistics {
    eventId: mongodb.ObjectID,
    eventDate: Date,
    gender: string,
    registered: number,
    checkedin: number
}

export interface IEventbriteEvent {
    id: string;
    date: Date;
}

export interface IEventbriteEventStatus {
    eventId: string;
    quantitySold: number;
    quantityTotal: number;
}

export interface IEventbriteAttendee {
    id: string;
    givenName: string;
    familyName: string;
    email: string;
    attending: boolean;
    yearOfBirth?: string;
    needsComputer?: boolean;
}

export interface IEventbritePagedResult<T> {
    pageNumber: number;
    pageCount: number;
    result: T[];
}

export interface IEventbriteTicketClass {
    id: string;
    name: string;
}

export interface IEventbriteQuestions {
    yearOfBirthQuestionId?: string;
    needsComputerQuestionId?: string;
}

export interface IEventbrite {
     getEvents() : Promise<IEventbriteEvent[]>;
     getAttendees(eventId: string, coderTicketClasses: string[]) : Promise<IEventbriteAttendee[]>;
     getCoderTicketClasses(eventId: string) : Promise<string[]>;
     getTicketClassStatuses(eventIds: string[]): Promise<IEventbriteEventStatus[]>;
}
