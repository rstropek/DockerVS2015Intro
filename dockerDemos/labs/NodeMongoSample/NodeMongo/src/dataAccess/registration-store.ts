import * as mongodb from 'mongodb';
import * as model from '../model';
import * as contracts from './contracts';
import StoreBase from './store-base';

class RegistrationStore extends StoreBase<model.IRegistration> implements contracts.IRegistrationStore {
    constructor(registrations: mongodb.Collection) { 
        super(registrations);
    }

    public async checkIn(event: model.IEvent, participant: model.IParticipant): Promise<boolean> {
        let existingCheckin = await this.collection.find({ "event.id": event._id, "participant.id": participant._id, checkedin: true }).toArray();
        if (existingCheckin.length > 0) {
            return false;
        }
        
        await this.collection.updateOne({ "event.id": event._id, "participant.id": participant._id },
            { $set: { event: { id: event._id, date: event.date }, 
                participant: { id: participant._id, givenName: participant.givenName, familyName: participant.familyName }, 
                checkedin: true } },
            { upsert: true });
        return true;
    }
    
    public async getNumberOfCheckins(participantId: mongodb.ObjectID) : Promise<number> {
        return await this.collection.find({ "participant.id": participantId, checkedin: true }).project({ _id: 0, checkedin: 1}).count(false);
    }
    
    public async getTotalNumberOfCheckins() : Promise<contracts.ITotalRegistrations[]> {
        return await this.collection.aggregate([
            { $match: { checkedin: true } },
            { $group: { _id: "$participant.id", totalNumberOfCheckins: { $sum: 1 }} }
        ]).toArray();
    }
    
    public async getByEventId(eventId: string, includeStatistics?: boolean): Promise<model.IRegistration[]> {
        var result = await this.collection.find({ "event.id": new mongodb.ObjectID(eventId) })
            .project({ "_id": 1, "participant": 1, "registered": 1, "checkedin": 1, "needsComputer": 1 })
            .sort({ "participant.familyName": 1 }).toArray();
        
        if (includeStatistics) {
            var stats = await this.getTotalNumberOfCheckins();
            result.forEach(r => {
                var participantStats = stats.filter(tr => tr._id.equals(r.participant.id));
                if (participantStats && participantStats.length > 0) {
                    r.totalNumberOfCheckins = participantStats[0].totalNumberOfCheckins;
                }
            });
        }

        return result;
    }
    
    public async upsertByEventAndParticipant(registration: model.IRegistration): Promise<model.IRegistration> {
        // Note that the following statement does not update the checkedin property.
        // Use method checkIn for that.
        let set : any = { event: registration.event, participant: registration.participant,
                registered: registration.registered };
        if (typeof registration.needsComputer !== "undefined") {
            set.needsComputer = registration.needsComputer;
        }
        
        let upsertResult = await this.collection.findOneAndUpdate(
            { "event.id": registration.event.id, "participant.id": registration.participant.id },
            { $set: set }, { upsert: true });
        return upsertResult.lastErrorObject.updatedExisting
            ? upsertResult.value
            : await this.getById(upsertResult.lastErrorObject.upserted);
    }

    public async getStatistics(checkinLimit?: number): Promise<contracts.IRegistrationStatistics[]> {
        let selector: any[] = [
            { $match: { checkedin: true } },
            { $group: { _id: "$participant.id", total: { $sum: 1 } } }
        ];
        if (checkinLimit) {
            selector.push({ $match: { total: { "$gte": checkinLimit } } });
        }

        let result = await this.collection.aggregate(selector).toArray();
        return result.map(row => { return { _id: row._id, totalNumberOfCheckins: row.total }; });
    }

    public async getGenderStatistics(): Promise<contracts.IGenderStatistics[]> {
        const result = await this.collection.aggregate([
            { $lookup: { from: 'participants', localField: 'participant.id', foreignField: '_id', as: 'participantOrig' } },
            { $unwind : "$participantOrig" },
            { $group: { 
                _id: { eventId: '$event.id', date: '$event.date', gender: { $ifNull: [ '$participantOrig.gender', 'u' ] }, checkedin: 'checkedin' }, 
                registered: { $sum: { $cond: { if: '$registered', then: 1, else: 0 } } },
                checkedin: { $sum: { $cond: { if: '$checkedin', then: 1, else: 0 } } } } 
            },
            { $sort: { '_id.date': 1, '_id.gender': 1 } }
        ]).toArray();

        return result.map(row => { return { 
            eventId: row._id.eventId,
            eventDate: row._id.date,
            gender: row._id.gender,
            registered: row.registered,
            checkedin: row.checkedin
        } });
    }
}

export default RegistrationStore;