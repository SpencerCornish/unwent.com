import 'package:angular2/core.dart';

import '../header/header.dart';
import '../../models/ring.dart';
import '../../services/firebase_service.dart';

@Component(
    selector: 'my-app',
    templateUrl: 'app.html',
    directives: const [Header],
    providers: const [FirebaseService])
class AppComponent {
  final FirebaseService fbService;
  String description;
  AppComponent(FirebaseService this.fbService);

  String timeAgo(String timeStamp) {
    Duration dur = new DateTime.now().difference(DateTime.parse(timeStamp));
    // the last minute
    if (dur.inMinutes == 0) return "just now";
    // Years ago
    if (dur.inDays > 364)
      return " ${(dur.inDays~/365)} year${dur.inDays/365 > 1 ? "s" : ""} ago";
    // Days ago
    if (dur.inHours > 24)
      return " ${dur.inDays} day${dur.inDays > 1 ? "s" : ""} ago";
    // Hours ago
    if (dur.inMinutes > 59)
      return " ${dur.inHours} hour${dur.inHours > 1 ? "s" : ""} ago";
    // Minutes ago
    return " ${dur.inMinutes} minute${dur.inMinutes > 1 ? "s" : ""} ago";
  }

  sendRing() {
    fbService.sendRing(description);
  }
}
