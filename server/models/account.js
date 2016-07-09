module.exports = function(Account) {
	delete Account.validations.password;
	delete Account.validations.email;

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
		{name:"updateAttributes", isStatic: false},
		{name:"login", isStatic: true},
		{name:"confirm", isStatic: true},
		{name:"resetPassword", isStatic: true},
		{name: "__get__accessTokens", isStatic: false},
		{name: "__create__accessTokens", isStatic: false},
		{name: "__find__accessTokens", isStatic: false},
		{name: "__count__accessTokens", isStatic: false},
		{name: "__findById__accessTokens", isStatic: false},
		{name: "__upsert__accessTokens", isStatic: false},
		{name: "__delete__accessTokens", isStatic: false},
		{name: "__destroyById__accessTokens", isStatic: false},
		{name: "__updateById__accessTokens", isStatic: false},

	];

	methods.forEach(function(method){
		Account.disableRemoteMethod(method.name, method.isStatic);		
	});

	
	//******************* Login by VK
	Account.remoteMethod("loginVK", {
		accepts: {arg: "accessToken", type: "string"},
	    returns: {arg: "profile", type: "string"},
	    description: "Login a user via VK access token",
	    http: {
	      path: "/login/vk",
	      verb: "POST"
	    }
	})
	Account.loginVK = function(token){
		return services.social.getAccessToken("vkontakte", token);
	}
};
