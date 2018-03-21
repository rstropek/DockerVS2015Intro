export interface IMongoObject { _id?: string; }

export interface IEvent extends IMongoObject {
  date: Date;
  location: string;
  eventbriteId?: string;
  quantitySold?: number;
  quantityTotal?: number;
}

export interface IParticipant extends IMongoObject {
    givenName?: string;
    familyName?: string;
    email?: string;
    googleSubject?: string;
    eventbriteId?: string;
    yearOfBirth?: string;
    gender?: string;
}