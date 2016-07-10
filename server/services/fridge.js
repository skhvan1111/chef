module.exports.get = get;
function get(currentUser){
	return app.models.Fridge.findOne({"ownerId": currentUser._id.toString()})
		.then((fridge)=>{
			if(fridge) return fridge;
			return createFridge(currentUser);
		})
}

module.exports.addProducts = function(currentUser, productIds){
	return get(currentUser)
	.then((fridge)=>{
		return updateFridge(fridge, productIds);	
	})
};

module.exports.removeProduct = function(currentUser, productId){
	return get(currentUser)
	.then((fridge)=>{
		fridge.products = _.filter(fridge.products, (product)=>{
			console.log("removeProduct", product.id, productId);
			return !product.id.equals(productId);
		});
		return fridge.save();
	})
};

function updateFridge(fridge, productIds = []){
	var existProductIds = _.chain(fridge.products).pluck("id").map((id)=>{ return id.toString() }).value();
	var newProductIds = _.chain(productIds).difference(existProductIds).map((productId)=>{
		return new app.dataSources.db.ObjectID(productId);
	})
	.value();

	return app.models.Product.find({where: { _id: {in: newProductIds} }})
		.then((products)=>{
			_.chain(products)
			.filter((product)=>{
				return newProductIds.indexOf(product.id) === -1;
			})
			.each((product)=>{
				fridge.products.push(product);
			})

			return fridge.save();	
		})
}

function removeProductFromFridge(fridge, productId){

}

function createFridge(currentUser){
	console.log("createFridge:",currentUser);
	return app.models.Fridge.create({
		ownerId: currentUser.id,
		products: []
	})
}