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

  Profile.none() {
    this.displayName = "Anonymouse user";
    this.photoURL = _getSafeUrl;
  }

  String get _getSafeUrl => "https://api.kwelo.com/v1/media/identicon/${uid}";

  String get safePhotoUrl => photoURL ?? _getSafeUrl;

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
