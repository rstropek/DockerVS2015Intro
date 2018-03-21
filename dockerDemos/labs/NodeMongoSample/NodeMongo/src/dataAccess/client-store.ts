import * as mongodb from 'mongodb';
import * as model from '../model';
import * as contracts from './contracts';
import StoreBase from './store-base';

class ClientStore extends StoreBase<model.IClientApp> implements contracts.IClientStore {
    constructor(clients: mongodb.Collection) {
        super(clients);
    }

    public async getByApiKey(apiKey: string): Promise<model.IClientApp> {
        let result = await this.collection.findOne({}/*{ apiKey: apiKey }*/);

        return result;
    }
}

export default ClientStore;