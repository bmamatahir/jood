import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jood/models/homeless_manifest.dart';

class Database {
  static Database _instance = Database._internalInitiator();

  Database._internalInitiator() {
    _ref = _db.collection("homelessManifest");
  }

  factory Database() {
    return _instance;
  }

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  CollectionReference _ref;

  Future<String> setHomeless(HomelessManifest homeless) async {
    var ref = await _ref.add(homeless.toJson());
    return ref.id;
  }

  Future<void> deleteHomeless(String id) {
    return _ref.doc(id).delete();
  }

  Stream<List<HomelessManifest>> homelessManifestsStream() {
    return _ref.snapshots().map(
        (e) => e.docs.map((e) => HomelessManifest.fromSnapshot(e)).toList());
  }

  Stream<HomelessManifest> singleHomelessManifestStream(
      {@required String homelessId}) {}
}
