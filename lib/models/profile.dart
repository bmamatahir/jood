import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  String uid;
  String email;
  String displayName;
  String photoURL;
  DateTime lastSeen;

  Profile({this.uid, this.email, this.displayName, this.photoURL, this.lastSeen});

  factory Profile.fromSnapshot(DocumentSnapshot snapshot) {
    var a = Profile.fromJson(snapshot.data())..uid = snapshot.id;
    return a;
  }

  static const _default_photo_url =
      "https://i4.sndcdn.com/avatars-xg1fZv1ULo6Rzun2-3fX8MQ-t500x500.jpg";

  Profile.none() {
    this.displayName = "Anonymouse user";
    this.photoURL = _default_photo_url;
  }

  String get safePhotoUrl  => photoURL ?? _default_photo_url;

  Profile.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    email = json['email'];
    displayName = json['displayName'];
    photoURL = json['photoURL'];
    lastSeen = (json['lastSeen'] as Timestamp).toDate();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['email'] = this.email;
    data['displayName'] = this.displayName;
    data['photoURL'] = this.photoURL;
    data['lastSeen'] = this.lastSeen;
    return data;
  }
}
