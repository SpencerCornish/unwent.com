import 'package:angular/angular.dart';

import '../../services/firebase_service.dart';

@Component(
  selector: 'header',
  templateUrl: 'header.html',
)
class Header {
  final FirebaseService fbService;

  Header(FirebaseService this.fbService);
}
