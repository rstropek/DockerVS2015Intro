import * as mongodb from 'mongodb';
import * as model from '../model';
import * as contracts from './contracts';
import StoreBase from './store-base';

class ParticipantStore extends StoreBase<model.IParticipant> implements contracts.IParticipantStore {
    constructor(participants: mongodb.Collection) { 
        super(participants);
    }

    public add(participant: model.IParticipant): Promise<model.IParticipant> {
        // Trim names
        participant.givenName = this.fixCasing(participant.givenName.trim());
        participant.familyName = this.fixCasing(participant.familyName.trim());
        if (participant.email) {
            participant.email = participant.email.trim();
        }

        return super.add(participant, model.isValidParticipant, e => {});
    }

    public async getByName(givenName: string, familyName: string): Promise<model.IParticipant> {
        let filter : any = { };
        if (givenName) {
            filter.givenName = this.fixCasing(givenName.trim());
        }
        
        if (familyName) {
            filter.familyName = this.fixCasing(familyName.trim());
        }
        
        let result = await this.collection.find(filter).limit(1).toArray();
        return (result.length !== 0) ? result[0] : null;
    }

    public async upsertByName(participant: model.IParticipant): Promise<model.IParticipant> {
        // Note that the following upsert does not set or modify the participant's roles.
        // That's not a bug, it is intended.
        let set : any = { 
            givenName: this.fixCasing(participant.givenName.trim()), 
            familyName: this.fixCasing(participant.familyName.trim()) 
        };
        if (typeof participant.email !== "undefined") {
            set.email = participant.email.trim();
        }
        
        if (typeof participant.eventbriteId !== "undefined") {
            set.eventbriteId = participant.eventbriteId;
        }
        
        if (typeof participant.yearOfBirth !== "undefined") {
            set.yearOfBirth = participant.yearOfBirth;
        }

        if (typeof participant.gender !== "undefined") {
            set.gender = participant.gender;
        }

        let upsertResult = await this.collection.findOneAndUpdate(
            { 
                givenName: { $regex: ["^", super.escapeRegexString(this.fixCasing(participant.givenName.trim())), "$"].join(""), $options: "i" }, 
                familyName: { $regex: ["^", super.escapeRegexString(this.fixCasing(participant.familyName.trim())), "$"].join(""), $options: "i" }
            }, 
            { $set: set }, 
            { upsert: true });
        return upsertResult.lastErrorObject.updatedExisting
            ? upsertResult.value
            : await this.getById(upsertResult.lastErrorObject.upserted);
    }
}

export default ParticipantStore;