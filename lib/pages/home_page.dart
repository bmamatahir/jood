import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:jood/code_runner.dart';
import 'package:jood/components/border_around_avatar.dart';
import 'package:jood/components/dropdown_avatar.dart';
import 'package:jood/components/list_map_switcher.dart';
import 'package:jood/models/homeless_manifest.dart';
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
      right: 20,
      child: SafeArea(
        child: DropDownAvatar(),
      ),
    );
  }

  SafeArea switcher(BuildContext context) {
    return SafeArea(
      child: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.only(top: 20, left: 20),
        child: ListMapSwitcher(
          onChange: (s) => context.read(mapViewProvider).state = s,
          value: context.read(mapViewProvider).state,
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
                      padding: EdgeInsets.only(top: 70),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        HomelessManifest homeless = snapshot.data[index];
                        return HomelessCardItem(homeless: homeless);
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

class HomelessCardItem extends StatelessWidget {
  final HomelessManifest homeless;

  const HomelessCardItem({Key key, this.homeless}) : super(key: key);

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

  header() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(homeless.reporter.displayName),
      subtitle: Text(homeless.timeAgo),
      leading: BorderAroundAvatar(
        child: CircleAvatar(
          backgroundImage: NetworkImage(homeless.reporter.safePhotoUrl),
        ),
      ),
    );
  }

  tableCellWrapper(property, String path, Text value) {
    return TableCell(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            path,
            width: 22,
            height: 22,
          ),
          SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                property,
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, height: 1),
              ),
              value,
            ],
          ),
        ],
      ),
    ));
  }

  statistics() {
    return Table(
        border: TableBorder.all(color: Colors.black12, style: BorderStyle.solid, width: 1),
        children: [
          TableRow(children: [
            tableCellWrapper(
                'Gender',
                'assets/icons/gender.svg',
                Text(homeless.familyRegistry.gender,
                    style: TextStyle(
                      color: homeless.male ? Colors.blue : Colors.pink,
                    ))),
            tableCellWrapper('Life stage', 'assets/icons/lifestage.svg',
                Text(homeless.familyRegistry.lifeStage)),
          ]),
          if (homeless.familyRegistry.married || homeless.familyRegistry.hasChildren)
            TableRow(children: [
              tableCellWrapper('Married', 'assets/icons/married.svg',
                  Text(homeless.familyRegistry.married ? 'Yes' : 'No')),
              tableCellWrapper('N° Children', 'assets/icons/baby.svg',
                  Text(homeless.familyRegistry.nbrChildren.toString())),
            ])
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(9),
      child: Padding(
        padding: const EdgeInsets.all(9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("#${homeless.id.substring(0, 6)}", style: TextStyle(color: Colors.black)),
                PopupMenuButton(
                    icon: Icon(Icons.more_vert_rounded),
                    onSelected: (v) {},
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem<dynamic>(
                          value: 'some-action',
                          child: Text('Some action'),
                        ),
                      ];
                    }),
              ],
            ),
            header(),
            statistics(),
            SizedBox(height: 8),
            smallHeader("Global needs"),
            Wrap(
              runSpacing: 9,
              spacing: 9,
              children: homeless.globalNeeds.map((e) => propertyViewer(e)).toList(),
            ),
            smallHeader("Physical appearance"),
            Wrap(
              runSpacing: 9,
              spacing: 9,
              children: homeless.physicalAppearance.map((e) => propertyViewer(e)).toList(),
            ),
            smallHeader("Psychological state"),
            Wrap(
              runSpacing: 9,
              spacing: 9,
              children: homeless.psychologicalState.map((e) => propertyViewer(e)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
