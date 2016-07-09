module.exports.getAccessToken = function(provider, token){
	return getOrCreateAccountByToken(provider, token)
	.then((account)=>{
		return account.createAccessToken(app.get("auth").ttl)
		.then((token)=> {
			return { token, account };
		});
	})
}

module.exports.getOrCreateAccountByToken = getOrCreateAccountByToken;
function getOrCreateAccountByToken(provider, token){
	return getService(provider).getOrCreateAccountByToken(token);
};

function getService(provider){
	return require("./" + provider);
}