const functions = require('firebase-functions');

// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);



// Keeps track of the length of the 'likes' child list in a separate property.
exports.countRingchange = functions.database.ref('/rings/{ringid}').onWrite(event => {
  const collectionRef = event.data.ref.parent;
  const countRef = admin.database().ref('/global/ringCount');


  // Return the promise from countRef.transaction() so our function
  // waits for this async event to complete before it exits.
  return countRef.transaction(current => {
    if (event.data.exists() && !event.data.previous.exists()) {
      return (current || 0) + 1;
    }
    else if (!event.data.exists() && event.data.previous.exists()) {
      return (current || 0) - 1;
    }
  }).then(() => {
    console.log('Counter updated.');
  });
});

// // If the number of likes gets deleted, recount the number of likes
// exports.recountHits = functions.database.ref('/posts/{postid}/likes_count').onWrite(event => {
//   if (!event.data.exists()) {
//     const counterRef = event.data.ref;
//     const collectionRef = counterRef.parent.child('likes');
//
//     // Return the promise from counterRef.set() so our function
//     // waits for this async event to complete before it exits.
//     return collectionRef.once('value')
//         .then(messagesData => counterRef.set(messagesData.numChildren()));
//   }
// });

exports.updateRingUid = functions.database.ref('/rings/{pushId}')
    .onWrite(event => {
      // Grab the current value of what was written to the Realtime Database.
      const original = event.data.val();
      console.log('processing ring ', event.params.pushId, original);
      // You must return a Promise when performing asynchronous tasks inside a Functions such as
      // writing to the Firebase Realtime Database.
      // Setting an "uppercase" sibling in the Realtime Database returns a Promise.
      return admin.database().ref('/global').child('lastUid').set(original['uid']);
    });
