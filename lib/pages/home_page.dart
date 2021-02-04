import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:jood/code_runner.dart';
import 'package:jood/components/dropdown_avatar.dart';
import 'package:jood/components/form_error.dart';
import 'package:jood/components/list_map_switcher.dart';
import 'package:jood/models/homeless_manifest.dart';
import 'package:jood/pages/homeless_card_item.dart';
import 'package:jood/pages/map.dart';
import 'package:jood/pages/report/report_homeless.dart';
import 'package:jood/report_button.dart';
import 'package:jood/services/homeless_crud.dart';

final mapViewProvider = StateProvider<Switcher>((ref) {
  return Switcher.list;
});

class HomePage extends HookWidget {
  static String routeName = "/home_page";

  @override
  Widget build(BuildContext context) {
    CodeRunner.run();
    var s = useProvider(mapViewProvider).state;
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: Switcher.values.indexOf(s),
            children: [
              list(),
              map(),
            ],
          ),
          switcher(context),
          avatar(),
        ],
      ),
      floatingActionButton: ReportButton(
        onPressed: () => Navigator.pushNamed(context, ReportHomeless.routeName),
      ),
    );
  }

  avatar() {
    return Positioned(
      top: 12,
      right: 5,
      child: SafeArea(
        child: DropDownAvatar(),
      ),
    );
  }

  SafeArea switcher(BuildContext context) {
    return SafeArea(
      child: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.only(top: 20, left: 15),
        child: ListMapSwitcher(
          onChange: (s) => context.read(mapViewProvider).state = s,
          value: context.read(mapViewProvider).state,
        ),
      ),
    );
  }

  map() {
    return SafeArea(
      child: MapSample(),
    );
  }

  error(error) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 200),
        child: FractionallySizedBox(widthFactor: .9, child: FormError(errors: [error])),
      ),
    );
  }

  Widget list() {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<HomelessManifest>>(
                stream: Database().homelessManifestsStream(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasError) return error(snapshot.error.toString());
                  if (snapshot.hasData) {
                    return ListView.builder(
                      padding: EdgeInsets.only(top: 70),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        HomelessManifest homeless = snapshot.data[index];
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: HomelessCardItem(homeless: homeless),
                        );
                      },
                    );
                  } else
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                }),
          ),
        ],
      ),
    );
  }
}