var loopback = require('loopback');
var boot = require('loopback-boot');

var app = module.exports = loopback();

// app.use(loopback.token());
// app.use(loopback.context());

// app.use(function setCurrentUser(req, res, next) {
//   if (!req.accessToken) {
//     return next();
//   }
//   app.models.Account.findById(req.accessToken.userId, function(err, user) {
//     if (err) {
//       return next(err);
//     }
//     if (!user) {
//       return next(new Error('No user with this access token was found.'));
//     }

//     console.log("setCurrentUser", user);
  
//     var loopbackContext = loopback.getCurrentContext();
//     if (loopbackContext) {
//       loopbackContext.set('currentUser', user);
//     }
//     next();
//   });
// });

app.start = function() {
  // start the web server
  return app.listen(function() {
    app.emit('started');
    var baseUrl = app.get('url').replace(/\/$/, '');
    console.log('Web server listening at: %s', baseUrl);
    if (app.get('loopback-component-explorer')) {
      var explorerPath = app.get('loopback-component-explorer').mountPath;
      console.log('Browse your REST API at %s%s', baseUrl, explorerPath);
    }
  });
};

const bootOptions = {
  appRootDir: __dirname,
  bootScripts: [
    "boot/root.js",
    "boot/globals.js",
    "boot/authentication.js"
  ]
};

boot(app, bootOptions, function(err) {
  if (err) throw err;
  app.start();
});