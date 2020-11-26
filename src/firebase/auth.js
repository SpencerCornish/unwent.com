import { auth, gAuthProvider } from './firebase';

export var user;


auth.onAuthStateChanged(function (newUser) {
    console.log('newUserChanged: ' + user);
    user = newUser;
})

export function createNewGoogleUser() {
    auth.signInWithPopup(gAuthProvider);
}

export function logOut() {
    auth.signOut();
}
