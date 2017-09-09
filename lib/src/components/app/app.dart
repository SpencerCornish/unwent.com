import 'dart:html';

import 'package:angular2/core.dart';

import '../header/header.dart';
import '../../services/firebase_service.dart';

@Component(
    selector: 'my-app',
    templateUrl: 'app.html',
    directives: const [Header],
    providers: const [FirebaseService])
class AppComponent {
  final FirebaseService fbService;

  AppComponent(FirebaseService this.fbService);
}
