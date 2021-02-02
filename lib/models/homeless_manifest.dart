import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:jood/helper/helpers.dart';
import 'package:jood/models/profile.dart';

class HomelessManifest {
  static const List<String> GENDERS = ["Male", "Female"];
  static const List<String> LIFE_STAGES = ["Child", "Adolescence", "Adult", "OldAge"];
  static const List<String> GLOBAL_NEEDS = [
    'Nourriture',
    'Vêtements',
    'Logement',
    'Médicaments',
    'Chaussures',
    'Eau',
    'Couverture',
    'Soins médicaux',
  ];
  static const List<String> PHYSICAL_APPEARANCE = [
    'Blessures',
    'Maigreur',
    'Déshydratés',
    'Handicap physique',
    'Handicap mentale',
  ];
  static const List<String> PSYCHOLOGICAL_STATE = [
    'Sous drogue',
    'Triste',
    'Dépressive',
    'Alcoolique',
    'Anxieuse',
    'Souriante',
    'Colérique',
  ];

  String id;
  List<String> globalNeeds;
  FamilyRegistry familyRegistry;
  List<String> physicalAppearance;
  List<String> psychologicalState;
  String reporterId;
  DateTime createdAt;
  Profile reporter;

  String get timeAgo => createdAt != null ? Helpers.formatTimeAgo(createdAt) : null;

  var _faker = Faker();

  HomelessManifest.random() {
    familyRegistry = FamilyRegistry(
      gender: _faker.randomGenerator.element(GENDERS),
      lifeStage: _faker.randomGenerator.element(LIFE_STAGES),
      married: false,
      nbrChildren: 0,
    );

    List<T> _randomElements<T>(List<T> list) {
      return _faker.randomGenerator
          .numbers(list.length - 1, _faker.randomGenerator.integer(list.length - 1))
          .map((position) => list[position])
          .toList();
    }

    globalNeeds = _randomElements(GLOBAL_NEEDS);
    physicalAppearance = _randomElements(PHYSICAL_APPEARANCE);
    psychologicalState = _randomElements(PSYCHOLOGICAL_STATE);
    reporterId = _faker.randomGenerator.string(50, min: 25);
  }

  HomelessManifest(
      {this.globalNeeds,
      this.familyRegistry,
      this.physicalAppearance,
      this.psychologicalState});

  HomelessManifest.fromJson(Map<String, dynamic> json) {
    globalNeeds = json['globalNeeds'].cast<String>();
    familyRegistry = json['familyRegistry'] != null
        ? new FamilyRegistry.fromJson(Map<String, dynamic>.from(json['familyRegistry']))
        : null;
    physicalAppearance = json['physicalAppearance'].cast<String>();
    psychologicalState = json['psychologicalState'].cast<String>();
    reporterId = json['reporter'];
    createdAt = (json['createdAt'] as Timestamp)?.toDate();
  }

  factory HomelessManifest.fromSnapshot(QueryDocumentSnapshot snapshot) {
    return HomelessManifest.fromJson(snapshot.data())..id = snapshot.id;
  }

  /*  {
    var data = snapshot.data();
    id = snapshot.id;
  }*/

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['globalNeeds'] = this.globalNeeds;
    if (this.familyRegistry != null) {
      data['familyRegistry'] = this.familyRegistry.toJson();
    }
    data['physicalAppearance'] = this.physicalAppearance;
    data['psychologicalState'] = this.psychologicalState;
    data['reporter'] = this.reporterId;
    data['createdAt'] = this.createdAt;
    return data;
  }

  @override
  String toString() {
    return JsonEncoder.withIndent("     ").convert(toJson());
  }

  bool get male => familyRegistry.gender == 'Male';
}

class FamilyRegistry {
  String gender;
  String lifeStage;
  bool married;
  int nbrChildren;

  bool get hasChildren => nbrChildren > 0;

  FamilyRegistry({this.gender, this.lifeStage, this.married, this.nbrChildren});

  FamilyRegistry.fromJson(Map<String, dynamic> json) {
    gender = json['gender'];
    lifeStage = json['lifeStage'];
    married = json['married'];
    nbrChildren = json['nbrChildren'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gender'] = this.gender;
    data['lifeStage'] = this.lifeStage;
    data['married'] = this.married;
    data['nbrChildren'] = this.nbrChildren;
    return data;
  }
}
