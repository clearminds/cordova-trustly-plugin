var argscheck = require('cordova/argscheck'), exec = require('cordova/exec');

var Trustly = {};

Trustly.startTrustlyFlow = function(arg, endUrls, successCallback, failureCallback) {
	cordova.exec(successCallback, failureCallback, 
			'Trustly', 'startTrustlyFlow', [arg, endUrls]);
};

module.exports = Trustly;
