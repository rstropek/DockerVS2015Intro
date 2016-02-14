/// <reference path="../typings/tsd.d.ts" />

interface ICustomer {
    _id?: number;
    firstName: string;
    lastName: string;
}

class CustomerController {
	constructor(private $http: ng.IHttpService) {
		this.refresh();
	}
	
	public customers: ICustomer[];
	
	refresh() {
		return this.$http.get<ICustomer[]>("/customers")
			.success(result => this.customers = result);
	}
	
	addCustomer() {
		var newCustomer: ICustomer = { firstName: "Test", lastName: "Turbo" };
		this.$http.post("/customers", newCustomer)
			.then(() => this.refresh());
	}
}

angular.module("SoftArchSummitApp", [])
	.controller("CustomerController", CustomerController);
