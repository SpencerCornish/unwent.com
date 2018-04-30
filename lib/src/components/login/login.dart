import 'package:angular/angular.dart';

import '../../services/firebase_service.dart';

@Component(
  selector: 'login',
  templateUrl: 'login.html',
  styleUrls: const ['login.css'],
  directives: const [COMMON_DIRECTIVES],
)
class LoginComponent {
  final FirebaseService fbService;

  LoginComponent(this.fbService);
}
