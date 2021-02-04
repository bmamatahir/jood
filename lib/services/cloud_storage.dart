import 'package:firebase_storage/firebase_storage.dart';

class CloudStorage {
  FirebaseStorage storage = FirebaseStorage.instance;

  test() {
    Reference ref = FirebaseStorage.instance.ref().child("map_screenshots").child("defaultProfile.png");
  }
}
