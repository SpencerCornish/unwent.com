import 'package:angular/angular.dart';
import 'package:angular/core.dart';
import '../../services/firebase_service.dart';

import '../login/login.dart';
import '../landing/landing.dart';

@Component(
    selector: 'my-app',
    templateUrl: 'app.html',
    directives: const [LoginComponent, LandingComponent, COMMON_DIRECTIVES],
    providers: const [FirebaseService])
class AppComponent {
  final FirebaseService fbService;
  String description;
  AppComponent(FirebaseService this.fbService);
  sendRing() {
    fbService.sendRing(description);
  }
}
