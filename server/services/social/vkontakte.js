var VK = require('vksdk');

module.exports.getOrCreateAccountByToken = function(token){
	var client = getClient(token);
	
	return getVkontakteProfile(client)
	.then((profile)=>{
		console.log("getVkontakteProfile:", profile);
		var id = profile ? profile.id : null;
		return getAccountByUserId(id).then((account)=>{
		 	return account ? account : createAccountByVKotakteProfile(profile);
		});
	});
};

function getAccountByUserId(userId){
	if(!userId) return Promise.resolve();
	return app.models.Account.findOne({where: {"tokens.userId": userId.toString()}});
}

function getVkontakteProfile(client){
	return new Promise(function(resolve, reject){
		client.request("users.get", {fields: ["photo_100"]}, (response)=> {
			console.log("getVkontakteProfile", response);
			return resolve(response.response.length > 0 ? response.response[0] : null);
		})
	});
}

function createAccountByVKotakteProfile(profile){
	return app.models.Account.create({
		username: `user_${profile.id}`,
		tokens: [{
			provider: app.models.SocialToken.PROVIDERS.vkontakte,
			userId: profile.id,
			fullName: `${profile.first_name} ${profile.last_name}`,
			email: profile.email
		}],
		avatarUrl: profile.photo_100
	})
}

function getClient(token){
	var config = app.get("social").vkontakte;
	console.log("VK client:", config);
	var client = new VK({
	   'appId'     : config.appId,
	   'appSecret' : config.appSecret,
	   'language'  : 'ru',
       'mode'      : 'oauth'
	});
	
	if(token) client.setToken(token);

	client.on('http-error', function(_e) {
	    console.log(_e);
	});

	client.on('parse-error', function(_e) {
	    console.log(_e);
	});

	client.setSecureRequests(true);

	return client;
}