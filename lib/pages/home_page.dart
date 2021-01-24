import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:jood/code_runner.dart';
import 'package:jood/components/list_map_switcher.dart';
import 'package:jood/models/homeless_manifest.dart';
import 'package:jood/pages/report/report_homeless.dart';
import 'package:jood/report_button.dart';
import 'package:jood/services/auth_service.dart';
import 'package:jood/services/homeless_crud.dart';

final mapViewProvider = StateProvider<Switcher>((ref) {
  return Switcher.map;
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
    return SafeArea(
      child: Container(
        alignment: Alignment.topRight,
        padding: const EdgeInsets.all(20),
//        decoration: BoxDecoration(boxShadow: [
//          BoxShadow(
//            color: Colors.black12,
//            blurRadius: 20,
//            offset: Offset(0, 5),
//          )
//        ]),
        child: GestureDetector(
          onTap: authService.signOut,
          child: CircleAvatar(
            backgroundImage: AssetImage("assets/images/Profile Image.png"),
          ),
        ),
      ),
    );
  }

  SafeArea switcher(BuildContext context) {
    return SafeArea(
      child: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(top: 20),
        child: ListMapSwitcher(
          onChange: (s) => context.read(mapViewProvider).state = s,
        ),
      ),
    );
  }

  map() {
    return SafeArea(
      child: Text(
          'The only way to learn a new programming language is by writing programs in it'),
    );
  }

  smallHeader(String text) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(fontSize: 12),
        ),
        SizedBox(width: 9),
        Expanded(child: Divider()),
      ],
    );
  }

  Widget propertyViewer(String property) {
    return Chip(
      label: Text(property),
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
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        HomelessManifest homeless = snapshot.data[index];
                        return Card(
                          margin: const EdgeInsets.all(9),
                          child: Padding(
                            padding: const EdgeInsets.all(9),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("#${homeless.id.substring(0, 6)}",
                                    style: TextStyle(color: Colors.black)),
                                smallHeader("Global needs"),
                                Wrap(
                                  runSpacing: 9,
                                  spacing: 9,
                                  children: homeless.globalNeeds
                                      .map((e) => propertyViewer(e))
                                      .toList(),
                                ),
                                smallHeader("Physical appearance"),
                                Wrap(
                                  runSpacing: 9,
                                  spacing: 9,
                                  children: homeless.physicalAppearance
                                      .map((e) => propertyViewer(e))
                                      .toList(),
                                ),
                                smallHeader("Psychological state"),
                                Wrap(
                                  runSpacing: 9,
                                  spacing: 9,
                                  children: homeless.psychologicalState
                                      .map((e) => propertyViewer(e))
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else
                    return Text('Emtpy Data');
                }),
          ),
        ],
      ),
    );
  }
}
