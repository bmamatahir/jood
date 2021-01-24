import 'package:flutter/material.dart' hide FormState;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jood/models/homeless_manifest.dart';
import 'package:jood/pages/report/state.dart';

class ReportForm extends StatelessWidget {
  sectionHeader(String text) {
    return [
      Text(text,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
      Divider(),
      SizedBox(height: 8),
    ];
  }

  globalRequirements(FormState state) {
    return Wrap(
      spacing: 20,
      children: HomelessManifest.GLOBAL_NEEDS
          .map((need) => InputChip(
                padding: EdgeInsets.all(5),
                avatar: CircleAvatar(
                  child: Text(need[0]),
                ),
                label: Text(need,
                    style: TextStyle(
                        color: state.selectedGlobalNeed(need)
                            ? Colors.white
                            : Colors.black)),
                selected: state.selectedGlobalNeed(need),
                selectedColor: Colors.blue.shade600,
                onSelected: (bool selected) {
                  state.addGlobalNeed(need);
                },
                onDeleted: state.selectedGlobalNeed(need)
                    ? () {
                        state.addGlobalNeed(need);
                      }
                    : null,
              ))
          .toList(),
    );
  }

  registryFamily(FormState state) {
    return [
      DropdownButtonFormField<String>(
        decoration: InputDecoration(
          filled: true,
          labelText: 'Gender',
        ),
        value: state.gender,
        items: HomelessManifest.GENDERS.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: state.setGender,
      ),
      SizedBox(height: 10),
      DropdownButtonFormField<String>(
        decoration: InputDecoration(
          filled: true,
          labelText: 'LifeStage',
        ),
        value: state.lifeStage,
        items: HomelessManifest.LIFE_STAGES.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: state.setLifeStage,
      ),
      SizedBox(height: 10),
      CheckboxListTile(
        title: Text("Married"),
        value: state.married,
        onChanged: state.setMarried,
        controlAffinity:
            ListTileControlAffinity.leading, //  <-- leading Checkbox
      ),
      if (state.married)
        TextField(
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: InputBorder.none,
            filled: true,
            labelText: 'Number of children',
          ),
          onChanged: state.setNumberOfChildren,
          onSubmitted: state.setNumberOfChildren,
        ),
    ];
  }

  physicalAppearanceChooser(FormState state) {
    return Wrap(
      spacing: 20,
      children: HomelessManifest.PHYSICAL_APPEARANCE
          .map((e) => InputChip(
                padding: EdgeInsets.all(5),
                avatar: CircleAvatar(
                  child: Text(e[0]),
                ),
                label: Text(e,
                    style: TextStyle(
                        color: state.selectedAppearance(e)
                            ? Colors.white
                            : Colors.black)),
                selected: state.selectedAppearance(e),
                selectedColor: Colors.blue.shade600,
                onSelected: (bool selected) {
                  state.addAppearance(e);
                },
                onDeleted: state.selectedAppearance(e)
                    ? () {
                        state.addAppearance(e);
                      }
                    : null,
              ))
          .toList(),
    );
  }

  psychologicalStateChooser(FormState state) {
    return Wrap(
      spacing: 20,
      children: HomelessManifest.PSYCHOLOGICAL_STATE
          .map((e) => InputChip(
                padding: EdgeInsets.all(5),
                avatar: CircleAvatar(
                  child: Text(e[0]),
                ),
                label: Text(e,
                    style: TextStyle(
                        color: state.selectedPsycho(e)
                            ? Colors.white
                            : Colors.black)),
                selected: state.selectedPsycho(e),
                selectedColor: Colors.blue.shade600,
                onSelected: (bool selected) {
                  state.addPsycho(e);
                },
                onDeleted: state.selectedPsycho(e)
                    ? () {
                        state.addPsycho(e);
                      }
                    : null,
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var formState = context.read(formStateProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...sectionHeader("SDF requirements"),
        globalRequirements(formState),
        SizedBox(height: 20),
        ...sectionHeader("Family Registry"),
        ...registryFamily(formState),
        SizedBox(height: 20),
        ...sectionHeader("Physical Appearance"),
        physicalAppearanceChooser(formState),
        SizedBox(height: 20),
        ...sectionHeader("Psychological State"),
        psychologicalStateChooser(formState),
        SizedBox(height: 20),
      ],
    );
  }
}
