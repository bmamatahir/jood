import 'package:flutter/material.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:jood/services/auth_service.dart';

class HomePage extends ConsumerWidget {
  static String routeName = "/home_page";

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/logo.png"),
            Text(
              'JOOD - Notre devoir de conscience',
            ),
            RaisedButton(
              onPressed: () {
                authService.signOut();
              },
              child: Text("Sign out"),
            ),
          ],
        ),
      ),
    );
  }
}
