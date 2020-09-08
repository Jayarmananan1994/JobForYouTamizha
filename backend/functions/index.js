const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);
const db = admin.firestore();
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

exports.sendNotification = functions.firestore
    .document('chats/{groupId1}/{groupId2}/{message}')
    .onCreate((snap, context) => {
        console.log('----------------start function--------------------')

        const doc = snap.data()
        console.log("doc here>>>>>>>>>>>>>>.")
        console.log(doc)
        var customProperties = doc['customProperties'];
        var user = doc['user'];
        var isAdminMsg = customProperties['deliverTo'] !== 'admin'
        var pushToken = "eOpcq7aYSmC5Zjda2ez6Qr:APA91bEUudEu1IiL5pDQwTZsav9mJYWyFgviTbWskQiLtIHkd7XzUmvv9k6QzmjzZuOzhgPT2hmshFg-OfvP0V_kniW64VVDPRyt2vT0W3rpyr9P__5YK3u-jTZkUrzSZrVzQCfina51";
        var senderName = (isAdminMsg) ? 'JobsForYouTamizha' : user.name;
    
        var payload = {
            notification: {
                title: `You have a message from ${senderName}`,
                body: doc['text'],
                badge: '1',
                sound: 'default'
            }
        }

        if (isAdminMsg) {
            console.log("to customerss >>>>>>>>");
            var chatroomId = customProperties['chatRoomId']
            console.log(chatroomId);
            const chatRoomInfoRef = db.collection('chatroom').doc(chatroomId);
            chatRoomInfoRef.get().then(doc => {
                if (doc.exists) {
                    var data = doc.data();
                    pushToken = data['customerDeviceToken'];
                    sendPushNotification(payload, pushToken);
                }
            });
        } else {
            console.log("to admnins    sda>>>>>>>>");
            const adminPhonesRef = db.collection('adminphones');
            const tokens = [];
            adminPhonesRef.get().then(snapshot => {
                console.log("to admnins>>>>>>>>");
                snapshot.forEach(doc => {
                    console.log(doc.data());
                    tokens.push(doc.data()['phonetoken']);
                });
                console.log(tokens);
                sendPushNotification(payload, tokens);
            }).catch(err => {
                console.log('Error getting document', err);
            });
        }
        return null
    })


function sendPushNotification(payload, pushToken) {
    // const payload = {
    //     notification: {
    //       title: `You have a message from some one`,
    //       body: "Soome push messgaeg",
    //       badge: '1',
    //       sound: 'default'
    //     }
    //   }
    // Let push to the target device
    admin
        .messaging()
        .sendToDevice(pushToken, payload)
        .then(response => {
            console.log('Successfully sent message:', response)
        })
        .catch(error => {
            console.log('Error sending message:', error)
        })
}