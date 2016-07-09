module.exports = function(Product) {

	var methods = [
		{name:"createChangeStream", isStatic: true},
		{name:"updateAll", isStatic: true},
		{name:"updateAttributes", isStatic: false},
	];

	methods.forEach(function(method){
		Product.disableRemoteMethod(method.name, method.isStatic);		
	});
};
