import 'dart:html';
import 'dart:async';

import 'package:angular2/core.dart';
import 'package:firebase/firebase.dart' as fb;

import '../models/ring.dart';
import '../models/user.dart';

@Injectable()
class FirebaseService {
  fb.User user;
  fb.Auth _fbAuth;
  fb.GoogleAuthProvider _fbGoogleAuthProvider;
  fb.Database _fbDatabase;
  fb.Storage _fbStorage;
  fb.DatabaseReference _fbRefRings;
  fb.DatabaseReference _fbRefUsers;
  fb.DatabaseReference _fbRefGlobal;

  int numRings;

  List<Ring> rings = [];

  Map<String, User> userList = new Map<String, User>();

  FirebaseService() {
    // Initialization of Firebase
    fb.initializeApp(
      apiKey: "AIzaSyDyadUWmvuzk3Wpw4ZJtOKxmQrJePCTuQg",
      authDomain: "gong-b2e93.firebaseapp.com",
      databaseURL: "https://gong-b2e93.firebaseio.com",
      storageBucket: "gong-b2e93.appspot.com",
    );
    // Auth
    _fbGoogleAuthProvider = new fb.GoogleAuthProvider();
    _fbAuth = fb.auth();
    _fbAuth.onAuthStateChanged.listen(_authUpdated);

    // Database
    _fbDatabase = fb.database();
    _fbRefRings = _fbDatabase.ref("rings");
    _fbRefGlobal = _fbDatabase.ref("global");
  }

  void _authUpdated(fb.AuthEvent event) {
    user = event.user;
    _addNewUser(new User(user.uid, user.displayName, user.photoURL));

    if (user != null) {
      _fbRefRings.limitToLast(10).onChildAdded.listen(_newRing);
    }
  }

  Future _addNewUser(User newUser) async {
    await _fbDatabase.ref("users/${newUser.uid}").set(newUser.toMap());
    userList[newUser.uid] = newUser;
  }

  void _newRing(fb.QueryEvent event) {
    print(event.snapshot.val());
    Ring newRing = new Ring.fromMap(event.snapshot.val(), event.snapshot.key);
    rings.add(newRing);
    _cacheUser(newRing.uid);
  }

  _cacheUser(String uid) async {
    if (userList.containsKey(uid)) return;
    var userRef = await _fbDatabase.ref('users/${uid}').once('value');
    User user = new User.fromMap(userRef.snapshot.key, userRef.snapshot.val());
    userList[uid] = user;
  }

  Future sendRing(String message) async {
    String time = new DateTime.now().toIso8601String();
    try {
      Ring ring = new Ring(false, 0, message, time, user.uid);
      await _fbRefRings.push().set(ring.toMap());
    } catch (error) {
      print("$runtimeType::sendMessage() -- $error");
    }
  }

  Future addLike(Ring ring) async {
    ring.likes += 1;
    _fbRefRings.child('${ring.uid}').set(ring.toMap());
  }

  Future signIn() async {
    try {
      await _fbAuth.signInWithPopup(_fbGoogleAuthProvider);
    } catch (error) {
      print("$runtimeType::login() -- $error");
    }
  }

  void signOut() {
    _fbAuth.signOut();
  }
}
