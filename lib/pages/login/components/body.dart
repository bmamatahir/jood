import 'package:flutter/material.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:jood/components/no_account_text.dart';
import 'package:jood/components/socal_card.dart';
import 'package:jood/services/auth_service.dart';

import 'login_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: (20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.04),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: (28),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Sign in with your email and password  \nor continue with social media",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: size.height * 0.08),
                LoginForm(),
                SizedBox(height: size.height * 0.08),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Consumer(
                      builder: (ctx, watch, child) {
                        return SocalCard(
                          icon: "assets/icons/google-icon.svg",
                          press: () async {
                            authService.signInWithGoogle();
                          },
                        );
                      },
                    ),
                    SocalCard(
                      icon: "assets/icons/facebook-2.svg",
                      press: () {},
                    ),
                    SocalCard(
                      icon: "assets/icons/twitter.svg",
                      press: () {},
                    ),
                  ],
                ),
                SizedBox(height: (20)),
                NoAccountText(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
