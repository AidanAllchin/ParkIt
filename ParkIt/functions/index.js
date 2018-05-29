const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);
const fb = admin.database();
var date = Date();
var array = date.split(' ');

exports.getFullDate = functions.https.onRequest((request, response) => {
	response.send(String(date));
});

exports.getMilitaryTime = functions.https.onRequest((request, response) => {
	response.send(String(array[4]));
});

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
// 	response.send("Hello from Firebase!");
// });
