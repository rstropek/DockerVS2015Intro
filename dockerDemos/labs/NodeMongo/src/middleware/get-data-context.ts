import * as express from "express";
import * as contracts from '../dataAccess/contracts';

function getDataContext(req: express.Request): contracts.IDataContext {
    return <contracts.IDataContext>((<any>(req.app)).dc);
}

export default getDataContext;