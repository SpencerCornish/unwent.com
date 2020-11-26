import firebase from 'firebase/app';
import 'firebase/auth';
var config = {
    apiKey: "AIzaSyDyadUWmvuzk3Wpw4ZJtOKxmQrJePCTuQg",
    authDomain: "gong-b2e93.firebaseapp.com",
    databaseURL: "https://gong-b2e93.firebaseio.com",
    projectId: "gong-b2e93",
    storageBucket: "gong-b2e93.appspot.com",
    messagingSenderId: "260168931670"
};

if (!firebase.apps.length) {
    firebase.initializeApp(config);
}

const auth = firebase.auth();

auth.onAuthStateChanged(function (user) {
    console.log("banana");
});
const gAuthProvider = new firebase.auth.GoogleAuthProvider();


export {
    auth,
    gAuthProvider,
};