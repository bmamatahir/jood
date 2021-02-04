import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:geocoder/geocoder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jood/helper/helpers.dart';
import 'package:jood/models/homeless_manifest.dart';
import 'package:jood/services/homeless_crud.dart';

class FormState extends StateNotifier<Map<String, dynamic>> {
  FormState()
      : super({
          "globalNeeds": [],
          "familyRegistry": {
            "gender": HomelessManifest.GENDERS.first,
            "lifeStage": HomelessManifest.LIFE_STAGES[1],
            "married": false,
            "nbrChildren": 0
          },
          "physicalAppearance": [],
          "psychologicalState": [],
          "mapScreenshot": null,
          "comment": null,
          "address": null,
          "gpsCoordinates": {
            "latitude": null,
            "longitude": null,
          }
        });

  String get gender => state['familyRegistry']['gender'];

  String get lifeStage => state['familyRegistry']['lifeStage'];

  bool get married => state['familyRegistry']['married'];

  int get nbrChildren => state['familyRegistry']['nbrChildren'];

  setGender(String gender) {
    setState({
      'familyRegistry': {...state['familyRegistry'], 'gender': gender}
    });
  }

  setLifeStage(String lifeStage) {
    setState({
      'familyRegistry': {...state['familyRegistry'], 'lifeStage': lifeStage}
    });
  }

  setGPSCoordinates(double latitude, double longitude) async {
    Address address =
        (await Geocoder.local.findAddressesFromCoordinates(Coordinates(latitude, longitude))).first;

    setState({
      'gpsCoordinates': {...state['gpsCoordinates'], 'latitude': latitude, 'longitude': longitude},
      'address': address.addressLine
    });
  }

  setMarried(bool married) {
    setState({
      'familyRegistry': {...state['familyRegistry'], 'married': married}
    });
  }

  setComment(String comment) {
    setState({'comment': comment.length == 0 ? null : comment});
  }

  setAddress(String address) {
    setState({'address': address});
  }

  setNumberOfChildren(String nbrChildren) {
    setState({
      'familyRegistry': {...state['familyRegistry'], 'nbrChildren': int.tryParse(nbrChildren) ?? 0}
    });
  }

  setState(map) {
    state = {...state, ...map};
  }

  addGlobalNeed(String n) {
    var list = [...state['globalNeeds']];
    if (selectedGlobalNeed(n))
      setState({'globalNeeds': list..remove(n)});
    else
      setState({
        'globalNeeds': [...list, n],
      });
  }

  bool selectedGlobalNeed(need) => state['globalNeeds'].contains(need);

  addAppearance(String value) {
    var list = [...state['physicalAppearance']];
    if (selectedAppearance(value))
      setState({'physicalAppearance': list..remove(value)});
    else
      setState({
        'physicalAppearance': [...list, value],
      });
  }

  addPsycho(value) {
    var list = [...state['psychologicalState']];
    if (selectedPsycho(value))
      setState({'psychologicalState': list..remove(value)});
    else
      setState({
        'psychologicalState': [...list, value],
      });
  }

  bool selectedAppearance(value) => state['physicalAppearance'].contains(value);

  bool selectedPsycho(value) => state['psychologicalState'].contains(value);

  setMapScreenshotData(Uint8List data) {
    if (data != null) setState({'mapScreenshot': data});
  }

  evaluate() {
    nullable(v) => v == null;

    if (nullable(state['mapScreenshot'])) {
      throw "Map preview is not available";
    }

    if (state['globalNeeds'].isEmpty &&
        state['physicalAppearance'].isEmpty &&
        state['psychologicalState'].isEmpty) {
      throw "At lease provide some data";
    }
  }

  void submit(void cb(), {Function(String message) error}) async {
    // print('>>> ${state['address']} ${state['gpsCoordinates']}');
    try {
      evaluate();
      // print(">>> ${state['mapScreenshot'].toString()}");
    } catch (e) {
      error(e);
      return;
    }

    final ref = await upload(state['mapScreenshot']);
    var entity = HomelessManifest.fromJson({...state, "mapScreenshot": ref.name});
    Database().setHomeless(entity);
    reset();
    if (cb != null) cb();
  }

  snapshotNameGenerator() {
    return "/IMG_${DateFormat('yyyyMMddHm').format(DateTime.now())}_${Helpers.getRandomString(7)}.jpg";
  }

  Future<Reference> upload(Uint8List fileBytes) async {
    Reference ref = FirebaseStorage.instance.ref('map_screenshots/${snapshotNameGenerator()}');

    try {
      await ref.putData(fileBytes);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print(">>> $e");
    }

    print('''
    name: ${ref.name}
    fullPath: ${ref.fullPath}
    ''');
    return ref;
  }

  reset() {
    state = {
      "globalNeeds": [],
      "familyRegistry": {
        "gender": HomelessManifest.GENDERS.first,
        "lifeStage": HomelessManifest.LIFE_STAGES[1],
        "married": false,
        "nbrChildren": 0
      },
      "physicalAppearance": [],
      "psychologicalState": []
    };
  }
}

final formStateProvider = StateNotifierProvider<FormState>((ref) {
  return FormState();
});
