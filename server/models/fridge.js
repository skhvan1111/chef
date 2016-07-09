var loopback = require("loopback");

module.exports = function(Fridge) {

	var methods = [
		{name:"updateAttributes", isStatic: true},
		{name:"create", isStatic: true},
		{name:"upsert", isStatic: true},
		{name:"exists", isStatic: true},
		{name:"findById", isStatic: true},
		{name:"find", isStatic: true},
		{name:"findOne", isStatic: true},
		{name:"destroyById", isStatic: true},
		{name:"deleteById", isStatic: true},
		{name:"count", isStatic: true},
		{name:"createChangeStream", isStatic: true},
		{name:"updateAll", isStatic: true},
		{name:"updateAttributes", isStatic: false}];

	methods.forEach(function(method){
		Fridge.disableRemoteMethod(method.name, method.isStatic);		
	});

	//******************** get mine fridge ********************
	Fridge.get = function(req){
		if(!req.currentUser) return Promise.reject();
		return app.services.fridge.get(req.currentUser);
	};

	Fridge.remoteMethod("get", {
		accepts: [
			{arg: 'req', type: 'object', 'http': {source: 'req'}},
		],
		returns: {arg: "fridge", type: "Fridge"},
	    description: "Get fridge products",
	    http: {
	      path: "/",
	      verb: "GET"
	    }
	});

	//******************** add fridge products ********************
	Fridge.addProducts = function(req, productIds){
		if(!req.currentUser) return Promise.reject();
		return app.services.fridge.addProducts(req.currentUser, productIds);
	};

	Fridge.remoteMethod("addProducts", {
		accepts: [
			{arg: 'req', type: 'object', 'http': {source: 'req'}},
			{arg: 'productIds', 'http': {source: 'body'}}
		],
		returns: {arg: "fridge", type: "Fridge"},
	    description: "Add products to fridge",
	    http: {
	      path: "/products",
	      verb: "POST"
	    }
	});

	//******************** remove fridge product ********************
	Fridge.removeProduct = function(req, productId){
		if(!req.currentUser) return Promise.reject();
		return app.services.fridge.removeProduct(req.currentUser, productId);
	};

	Fridge.remoteMethod("removeProduct", {
		accepts: [
			{arg: 'req', type: 'object', http: {source: 'req'}},
			{arg: 'productId', type: 'String', http: {source: 'path'}}
		],
		returns: {arg: "fridge", type: "Fridge"},
	    description: "Remove product from fridge by id",
	    http: {
	      path: "/products/:productId",
	      verb: "DELETE"
	    }
	});
};
