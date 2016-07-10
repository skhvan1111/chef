module.exports.updateIngredients = function(recipes, currentUser){
	recipes = _.isArray(recipes) ? recipes : [recipes];
	return app.services.fridge.get(currentUser)
	.then((fridge)=>{
		var fridgeProductIds = _.chain(fridge.products).map((product)=>{ return product.id.toString() }).value();
		return Promise.mapSeries(recipes, (recipe)=>{
			_.each(recipe.ingredients, (ingredient)=>{
				ingredient.isOutOfFridge = isOutOfFridge(fridgeProductIds, ingredient);
			});
		})
	});
}

function isOutOfFridge(fridgeProductIds, ingredient){
	return fridgeProductIds.indexOf(ingredient.id.toString()) === -1;
}