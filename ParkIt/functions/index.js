const functions = require('firebase-functions');

admin.initializeApp(functions.config().firebase);
const fb = admin.database()

exports.getCurrentTime = functions.https.onRequest((request, response) => {
	response.send(admin.database.ServerValue.TIMESTAMP);
})

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
