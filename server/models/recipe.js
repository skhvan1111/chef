module.exports = function(Recipe) {
	var methods = [
		{name:"updateAttributes", isStatic: true},
		{name:"create", isStatic: true},
		{name:"upsert", isStatic: true},
		{name:"exists", isStatic: true},
		// {name:"findById", isStatic: true},
		// {name:"find", isStatic: true},
		{name:"findOne", isStatic: true},
		{name:"destroyById", isStatic: true},
		{name:"deleteById", isStatic: true},
		// {name:"count", isStatic: true},
		{name:"createChangeStream", isStatic: true},
		{name:"updateAll", isStatic: true},
		{name:"updateAttributes", isStatic: false}
		];

	methods.forEach(function(method){
		Recipe.disableRemoteMethod(method.name, method.isStatic);		
	});

	Recipe.afterRemote("find", function(ctx,cb, cb1){
		return app.services.recipe.updateIngredients(ctx.result, ctx.req.currentUser)
		.asCallback(cb1);
	})

	Recipe.afterRemote("findById", function(ctx,cb, cb1){
		return app.services.recipe.updateIngredients(ctx.result, ctx.req.currentUser)
		.asCallback(cb1);
	})

};
