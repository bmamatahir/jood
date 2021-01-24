import 'package:flutter/widgets.dart';
import 'package:jood/forgot_password/forgot_password_screen.dart';
import 'package:jood/pages/home_page.dart';
import 'package:jood/pages/login/login_page.dart';
import 'package:jood/pages/register/register_page.dart';
import 'package:jood/pages/report/report_homeless.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  LoginPage.routeName: (context) => LoginPage(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  RegisterPage.routeName: (context) => RegisterPage(),
  HomePage.routeName: (context) => HomePage(),
  ReportHomeless.routeName: (context) => ReportHomeless(),
};
