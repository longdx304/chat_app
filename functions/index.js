const functions = require("firebase-functions");
// The Firebase Admin SDK to access Firestore.
const admin = require("firebase-admin");
admin.initializeApp();

exports.chatNotification = functions.firestore
    .document("chat/{messageId}")
    .onCreate((snapshot, context) => {
      admin.messaging().sendToTopic("chat", {
        notification: {
          title: snapshot.data().username,
          body: snapshot.data().text,
        },
      });
    });
