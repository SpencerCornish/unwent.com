import 'dart:async';

class Ring {
  bool confirmed;
  // Firebase Ring ID
  final String ringId;
  // User ID
  final String uid;
  // Message to place in notification
  String message;
  // Timestamp of ring
  final String timeStamp;

  String formattedTime;
  // Users who have liked this ring message
  Map<String, bool> likes;

  // Periodic timer to update the formatting string.
  Timer updateFormattedTime;

  Ring(this.confirmed, Map<String, bool> likes, this.message, this.timeStamp,
      this.uid,
      [this.ringId]) {
    this.likes = likes ?? new Map<String, bool>();
    // Initialize the formatted string for duration
    formattedTime = _timeAgo();

    updateFormattedTime = new Timer.periodic(
        new Duration(minutes: 1), (_) => formattedTime = _timeAgo());
  }

  Ring.fromMap(Map map, String ringId)
      : this(
          map['confirmed'],
          map['likes'],
          map['message'],
          map['timeStamp'],
          map['uid'],
          ringId,
        );

  Map toMap() => {
        "confirmed": confirmed,
        "message": message,
        "timeStamp": timeStamp,
        "uid": uid,
        "ringId": ringId,
      };

  String _timeAgo() {
    Duration dur = new DateTime.now().difference(DateTime.parse(timeStamp));
    // the last minute
    if (dur.inMinutes == 0) return "just now";
    // Years ago
    if (dur.inDays > 364) {
      print("Cancelling timer");
      updateFormattedTime?.cancel();
      return " ${(dur.inDays~/365)} year${dur.inDays/365 > 1 ? "s" : ""} ago";
    }
    // Days ago
    if (dur.inHours > 24) {
      print("Cancelling timer");
      updateFormattedTime?.cancel();
      return " ${dur.inDays} day${dur.inDays > 1 ? "s" : ""} ago";
    }
    // Hours ago
    if (dur.inMinutes > 59)
      return " ${dur.inHours} hour${dur.inHours > 1 ? "s" : ""} ago";
    // Minutes ago
    return " ${dur.inMinutes} minute${dur.inMinutes > 1 ? "s" : ""} ago";
  }

  void parseChanges(Map map) {
    confirmed = map['confirmed'];
    likes = map['likes'] ?? new Map<String, bool>();
    message = map['message'];
  }
}
