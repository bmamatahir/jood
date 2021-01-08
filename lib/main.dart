import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jood/pages/home_page.dart';
import 'package:jood/pages/login/login_page.dart';
import 'package:jood/routes.dart';
import 'package:jood/services/auth_service.dart';
import 'package:jood/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(ProviderScope(child: MyApp()));
}

final userProvider = StreamProvider<User>((ref) {
  return authService.user;
});

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jood',
      theme: theme(),
      home: AuthenticationWrapper(),
      routes: routes,
      builder: BotToastInit(), //1. call BotToastInit
      navigatorObservers: [
        BotToastNavigatorObserver()
      ], //2. registered route observer
    );
  }
}

class AuthenticationWrapper extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return watch(userProvider).when(
      data: (user) {
        // print("\$\$firebaseUser: ${user}");

        if (user != null) {
          return HomePage();
          // return MapSample();
        }
        return LoginPage();
      },
      loading: () => CircularProgressIndicator(),
      error: (e, s) => SizedBox(),
    );
  }
}
