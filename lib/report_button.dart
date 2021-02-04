import 'package:flutter/material.dart';
import 'package:jood/constants.dart';
import 'package:jood/request_permissions.dart';
import 'package:permission_handler/permission_handler.dart';

class ReportButton extends StatelessWidget {
  final VoidCallback onPressed;
  final VoidCallback onRefusePermission;

  const ReportButton({Key key, this.onPressed, this.onRefusePermission}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: onPressed == null ? Colors.grey : kPrimaryColor,
      onPressed: onPressed != null
          ? () async {
              bool granted = await RequestPermission().ask(context)(
                Permission.location,
                title: Text('Make easy access for volunteers to find the homeless'),
                message:
                    Text("Identifying homeless location needs access to \"location\" permission"),
              );
              if (!granted) {
                if (onRefusePermission != null) onRefusePermission();
                return;
              }
              onPressed();
            }
          : null,
      isExtended: true,
      tooltip: 'Report',
      icon: Icon(Icons.ios_share),
      label: Text('Signal'),
    );
  }
}
