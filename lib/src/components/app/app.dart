import 'package:angular/angular.dart';
import 'package:angular/core.dart';

import '../header/header.dart';
import '../../services/firebase_service.dart';

@Component(
    selector: 'my-app',
    templateUrl: 'app.html',
    directives: const [Header],
    styleUrls: const ['app.css'],
    providers: const [FirebaseService])
class AppComponent {
  final FirebaseService fbService;
  String description;
  AppComponent(FirebaseService this.fbService);
  sendRing() {
    fbService.sendRing(description);
  }
}
