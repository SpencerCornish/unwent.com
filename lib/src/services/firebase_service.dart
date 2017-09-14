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

  List<Ring> rings;

  Map<String, User> localUserList;

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
    _fbRefUsers = _fbDatabase.ref("users");
    _fbRefGlobal = _fbDatabase.ref("global");
  }

  void _authUpdated(fb.AuthEvent event) {
    user = event.user;

    //_fbRefUsers.push({});

    if (user != null) {
      _fbRefRings.limitToLast(10).onChildAdded.listen(_newRing);
      _addNewUser(new User(user.uid, user.displayName, user.photoURL));
    }
  }

  Future _addNewUser(User newUser) async {
    await _fbRefUsers.push().set(newUser.toMap());
  }

  void _newRing(fb.QueryEvent event) {
    print(event.snapshot.val());
    Ring newRing = new Ring.fromMap(event.snapshot.val(), event.snapshot.key);
    rings.add(newRing);
  }

  Future sendRing(String message) async {
    String time = new DateTime.now().toIso8601String();
    try {
      Ring ring = new Ring(false, 99, message, time, user.uid);
      await _fbRefRings.push().set(ring.toMap());
    } catch (error) {
      print("$runtimeType::sendMessage() -- $error");
    }
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
