class User {
  // Firebase User ID
  String uid;
  // Username
  String displayName;
  // Avatar image url
  String avatarUrl;
  // Message to place in notification
  String lastRingId;

  // Users who have liked this ring message
  int numRings;
  User(this.uid, this.displayName, this.avatarUrl, [this.lastRingId]);

  User.fromMap(String uid, Map map)
      : this(
          map['uid'],
          map['displayName'],
          map['avatarUrl'],
          map['lastRingId'],
        );

  Map toMap() => {
        "displayName": displayName,
        "avatarUrl": avatarUrl,
        "lastRingId": lastRingId,
      };
}
