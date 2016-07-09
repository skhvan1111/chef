module.exports = function(app){
  global.app = app;
  global.Promise = require("bluebird");
  global._ = require("underscore");
  global.services = app.services = require("../services");
};
