import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:jood/components/border_around_avatar.dart';
import 'package:jood/constants.dart';
import 'package:jood/models/homeless_manifest.dart';
import 'package:marquee/marquee.dart';

class HomelessCardItem extends HookWidget {
  final HomelessManifest homeless;

  HomelessCardItem({Key key, this.homeless}) : super(key: key);

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
      contentPadding: const EdgeInsets.only(left: 10),
      title: Text(homeless.reporter.displayName),
      subtitle: SizedBox(
        height: 20,
        child: Marquee(
          text: homeless.address,
          blankSpace: 20.0,
          velocity: 10.0,
          pauseAfterRound: Duration(seconds: 3),
          startAfter: Duration(seconds: 2),
        ),
      ),
      leading: BorderAroundAvatar(
        child: CircleAvatar(
          backgroundImage: NetworkImage(homeless.reporter.safePhotoUrl),
        ),
      ),
      trailing: PopupMenuButton(
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

  String _downloadUrl;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          header(),
          // map preview
          FutureBuilder(
              future: _downloadUrl != null
                  ? Future.value(_downloadUrl)
                  : FirebaseStorage.instance
                      .ref('map_screenshots/${homeless.mapScreenshot}')
                      .getDownloadURL(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                _downloadUrl = snapshot.data;
                return CachedNetworkImage(
                  imageUrl: snapshot.hasData ? _downloadUrl : "http://via.placeholder.com/414x200",
                  errorWidget: (context, url, error) => Icon(Icons.error),
                );
              }),

          // date time and reaction buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat.yMMMEd().add_jm().format(homeless.createdAt),
                    style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w600)),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.share_rounded, color: kTextColor),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.comment, color: kTextColor),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          // More info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15).copyWith(bottom: 10),
            child: ExpandablePanel(
              headerAlignment: ExpandablePanelHeaderAlignment.center,
              header: Text(
                "Requirements",
              ),
              expanded: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  statistics(),
                  SizedBox(height: 8),
                  if (homeless.hasGlobalNeeds) ...[
                    smallHeader("Global needs"),
                    Wrap(
                      runSpacing: 9,
                      spacing: 9,
                      children: homeless.globalNeeds.map((e) => propertyViewer(e)).toList(),
                    ),
                  ],
                  if (homeless.hasPhysicalAppearance) ...[
                    smallHeader("Physical appearance"),
                    Wrap(
                      runSpacing: 9,
                      spacing: 9,
                      children: homeless.physicalAppearance.map((e) => propertyViewer(e)).toList(),
                    ),
                  ],
                  if (homeless.hasPsychologicalState) ...[
                    smallHeader("Psychological state"),
                    Wrap(
                      runSpacing: 9,
                      spacing: 9,
                      children: homeless.psychologicalState.map((e) => propertyViewer(e)).toList(),
                    ),
                  ],
                ],
              ),
              tapHeaderToExpand: true,
              hasIcon: true,
            ),
          ),
        ],
      ),
    );
  }
}
