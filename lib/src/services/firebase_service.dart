import 'dart:async';

import 'package:angular/angular.dart';
import 'package:firebase/firebase.dart' as fb;

import '../models/ring.dart';
import '../models/user.dart';

@Injectable()
class FirebaseService {
  fb.User user;
  fb.Auth _fbAuth;
  fb.GoogleAuthProvider _fbGoogleAuthProvider;
  fb.Database _fbDatabase;
  //fb.Storage _fbStorage;
  fb.DatabaseReference _fbRefRings;

//////////
  /// Getters
//////////

  int _totalRings;
  int get totalRings => _totalRings;

  User _lastRinger;
  User get lastRinger => _lastRinger;

  Map<String, User> get userList => _userList;
  Map<String, User> _userList = new Map<String, User>();

  Map<String, Ring> get rings => _rings;
  Map<String, Ring> _rings = new Map<String, Ring>();

  // Get a ringList that prints in a nice order
  List<Ring> get ringList {
    List<Ring> unsortedList = _rings.values.toList();
    unsortedList.sort((a, b) => _compareRings(a, b));
    return unsortedList;
  }

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
    _fbRefRings = fb.database().ref('rings');
  }

  _globalUpdated(fb.QueryEvent event) async {
    _totalRings = event.snapshot.val()['ringCount'];

    String lastUid = event.snapshot.val()['lastUid'];
    await _cacheUser(lastUid);
    _lastRinger = userList[lastUid];
  }
//////////////
  /// Ring Section
//////////////

  /// Processes incoming ring from the firebase db
  Future _newRingFromFirebase(fb.QueryEvent event) async {
    Ring newRing = new Ring.fromMap(event.snapshot.val(), event.snapshot.key);
    await _cacheUser(newRing.uid);
    _rings[event.snapshot.key] = newRing;
  }

  /// Updates local ring data against firebase
  void _ringChanged(fb.QueryEvent event) {
    _rings[event.snapshot.key].parseChanges(event.snapshot.val());
  }

  void _ringRemoved(fb.QueryEvent event) {
    _rings.remove(event.snapshot.key);
  }

  /// Create and send a ring to the server
  Future sendRing(String message) async {
    String time = new DateTime.now().toIso8601String();
    try {
      Ring ring =
          new Ring(false, new Map<String, bool>(), message, time, user.uid);
      await _fbRefRings.push().set(ring.toMap());
    } catch (error) {
      print("$runtimeType::sendMessage() -- $error");
    }
  }

  /// Add a like to a ring
  Future toggleLike(String ringId) async {
    if (_rings[ringId].likes.containsKey(user.uid)) {
      await _fbDatabase.ref('rings/${ringId}/likes/${user.uid}').remove();
    } else {
      await _fbDatabase.ref('rings/${ringId}/likes/${user.uid}').set(true);
    }
  }

  /// Compares rings based on their timestamps
  _compareRings(Ring a, Ring b) {
    DateTime aDate = DateTime.parse(a.timeStamp);
    DateTime bDate = DateTime.parse(b.timeStamp);
    if (aDate.compareTo(bDate) == 0) return 0;
    if (aDate.compareTo(bDate) < 0) return 1;
    if (aDate.compareTo(bDate) > 0) return -1;
  }

//////////
  /// User/Auth Section
//////////

  /// Sign in the current user.  Generates dialog, etc.
  Future signIn() async {
    try {
      await _fbAuth.signInWithPopup(_fbGoogleAuthProvider);
    } catch (error) {
      await _fbAuth.signInWithRedirect(_fbGoogleAuthProvider);
      print("$runtimeType::login() -- $error");
    }
  }

  /// Sign out the current user
  void signOut() {
    _fbAuth.signOut();
  }

  /// when auth changes one way or another
  void _authUpdated(fb.AuthEvent event) {
    user = event.user;
    // Add/Update the user in Firebase
    _addNewUser(new User(user.uid, user.displayName, user.photoURL));

    // Logged in:
    if (user != null) {
      _fbRefRings.onChildAdded.listen(_newRingFromFirebase);
      _fbRefRings.onChildChanged.listen(_ringChanged);
      _fbRefRings.onChildRemoved.listen(_ringRemoved);

      _fbDatabase.ref('global/').onValue.listen(_globalUpdated);
    }
  }

  /// Add the updated current user on firebase
  Future _addNewUser(User newUser) async {
    await _fbDatabase.ref("users/${newUser.uid}").set(newUser.toMap());
    _userList[newUser.uid] = newUser;
  }

  /// Locally cache user we care about in our map.  Returns the user if already stored, and after caching
  _cacheUser(String uid) async {
    if (_userList.containsKey(uid)) return;
    var userRef = await _fbDatabase.ref('users/${uid}').once('value');
    _userList[uid] =
        new User.fromMap(userRef.snapshot.key, userRef.snapshot.val());
  }
}
