import 'package:angular/angular.dart';

import '../../services/firebase_service.dart';
import '../ring-form/ring-form.dart';

@Component(
  selector: 'landing',
  templateUrl: 'landing.html',
  styleUrls: const ['landing.css'],
  directives: const [COMMON_DIRECTIVES, RingFormComponent],
)
class LandingComponent {
  final FirebaseService fbService;
  LandingComponent(this.fbService);
  bool get canRing {
    if (fbService.timeToNextRing != null) {
      return fbService.timeToNextRing.isBefore(new DateTime.now());
    }
    return false;
  }

  int get timeDifference => fbService.timeToNextRing.difference(new DateTime.now()).inSeconds;
  List<String> get options => ['Quiet', 'Loud', 'Obnoxious'];
}
