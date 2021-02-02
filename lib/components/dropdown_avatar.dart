import 'package:flutter/material.dart';
import 'package:jood/components/border_around_avatar.dart';
import 'package:jood/models/profile.dart';
import 'package:jood/services/auth_service.dart';

class DropDownAvatar extends StatefulWidget {
  @override
  _DropDownAvatarState createState() => _DropDownAvatarState();
}

class _DropDownAvatarState extends State<DropDownAvatar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: StreamBuilder<Profile>(
          stream: authService.profile,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            Profile p = snapshot.hasData ? snapshot.data : Profile.none();

            return PopupMenuButton(
                offset: Offset(0, 100),
                icon: BorderAroundAvatar(
                  child: CircleAvatar(
                    minRadius: 20,
                    backgroundImage: NetworkImage(p.safePhotoUrl),
                  ),
                ),
                onSelected: (v) {
                  if (v == "sign-out") {
                    authService.signOut();
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<dynamic>(
                      enabled: false,
                      child: Text.rich(
                        TextSpan(children: [
                          TextSpan(text: 'Signed in as\n'),
                          TextSpan(text: p.displayName, style: TextStyle(color: Colors.black)),
                        ]),
                      ),
                    ),
                    PopupMenuItem<dynamic>(
                      value: 'sign-out',
                      child: Text('Sign out', style: TextStyle(color: Colors.red)),
                    ),
                  ];
                });
          }),
    );
  }
}
