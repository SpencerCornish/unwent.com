class Ring {
  bool confirmed;
  // Firebase Ring ID
  final String ringId;
  // User ID
  String uid;
  // Message to place in notification
  final String message;
  // Timestamp of ring
  final String timeStamp;
  // Users who have liked this ring message
  int likes;

  Ring(this.confirmed, this.likes, this.message, this.timeStamp, this.uid,
      [this.ringId]);

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
        "likes": likes,
        "message": message,
        "timeStamp": timeStamp,
        "uid": uid,
        "ringId": ringId,
      };
}
