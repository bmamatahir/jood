import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class RequestPermission {
  static RequestPermission _instance = RequestPermission._internalInitiator();

  RequestPermission._internalInitiator();

  factory RequestPermission() {
    return _instance;
  }

  Function(Permission permission, {Widget title, Widget message}) ask(BuildContext context) {
    return (Permission permission, {Widget title, Widget message}) async {
      PermissionStatus status = await permission.status;

      String pn = _getPermissionName(permission);
      String messageBody = "This application requires access to  $pn";

      Widget dialogTitle = title ?? Text("Use $pn?");
      Widget dialogBodyMessage = message ?? Text(messageBody);

      if (status.isGranted) return true;

      if (status.isPermanentlyDenied) UnimplementedError();

      if (status.isDenied || status.isUndetermined) {
        return await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: dialogTitle,
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[dialogBodyMessage],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'Cancel',
                  ),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                FlatButton(
                  child: Text(
                    'Allow',
                  ),
                  onPressed: () async {
                    PermissionStatus $r = await permission.request();
                    Navigator.of(context).pop($r.isGranted);
                  },
                ),
              ],
            );
          },
        );
      }
    };
  }

  // Future<bool> askMultiple(List<Permission> permissions) async {
  //   var $r = await Future.wait<bool>(permissions.map((e) => ask(e)).toList());
  //   return $r.every((e) => e == true);
  // }

  String _getPermissionName(Permission permission) {
    return permission.toString().split(".").last;
  }
}
