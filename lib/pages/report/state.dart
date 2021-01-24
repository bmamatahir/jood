import 'package:hooks_riverpod/hooks_riverpod.dart';
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
          "psychologicalState": []
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

  setMarried(bool married) {
    setState({
      'familyRegistry': {...state['familyRegistry'], 'married': married}
    });
  }

  setNumberOfChildren(String nbrChildren) {
    setState({
      'familyRegistry': {
        ...state['familyRegistry'],
        'nbrChildren': int.tryParse(nbrChildren) ?? 0
      }
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

  void submit([void cb()]) {
    var entity = HomelessManifest.fromJson(state);
    Database().setHomeless(entity);
    reset();
    if (cb != null) cb();
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
