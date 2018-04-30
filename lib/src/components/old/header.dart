import 'package:angular/angular.dart';

import '../../services/firebase_service.dart';

@Component(
  selector: 'header',
  templateUrl: 'header.html',
  directives: const [COMMON_DIRECTIVES],
)
class Header {
  final FirebaseService fbService;

  Header(FirebaseService this.fbService);
}
