import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jood/models/homeless_manifest.dart';
import 'package:jood/models/profile.dart';
import 'package:jood/services/auth_service.dart';
import 'package:rxdart/rxdart.dart';

class Database {
  static Database _instance = Database._internalInitiator();

  Database._internalInitiator() {
    _homelessRef = _db.collection("homelessManifest");
    _usersRef = _db.collection("users");
  }

  factory Database() {
    return _instance;
  }

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference _homelessRef;
  CollectionReference _usersRef;

  Future<String> setHomeless(HomelessManifest homeless) async {
    homeless
      ..reporterId = authService.userInfo.uid
      ..createdAt = DateTime.now();
    var ref = await _homelessRef.add(homeless.toJson());
    return ref.id;
  }

  Future<void> deleteHomeless(String id) {
    return _homelessRef.doc(id).delete();
  }

  //
  // Stream<List<HomelessManifest>> homelessManifestsStream() {
  //   return _ref.snapshots().map(
  //       (e) => e.docs.map((e) => HomelessManifest.fromSnapshot(e)).toList());
  // }

  Stream<List<HomelessManifest>> homelessManifestsStream() {
    var s = _homelessRef.snapshots().switchMap((e) {
      List<HomelessManifest> $r = e.docs.map((e) => HomelessManifest.fromSnapshot(e)).toList();

      var getHomeless = (String id) => $r.firstWhere((h) => h.reporterId == id, orElse: null);
      var usersHasSignals = () => [...$r].map((e) => e.reporterId).toList().cast<String>();

      return _usersRef.where('uid', whereIn: usersHasSignals()).get().asStream().map((qs) =>
          qs.docs.map((p) => getHomeless(p.id)..reporter = Profile.fromSnapshot(p)).toList());
    });
    return s;
  }

  Stream<HomelessManifest> singleHomelessManifestStream({@required String homelessId}) {}
}