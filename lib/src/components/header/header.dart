import 'package:angular2/angular2.dart';

import '../../services/firebase_service.dart';

@Component(
  selector: 'header',
  templateUrl: 'header.html',
)
class Header {
  final FirebaseService fbService;

  Header(FirebaseService this.fbService);
}
