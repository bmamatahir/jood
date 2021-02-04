import 'package:flutter/material.dart';

// const kPrimaryColor = Color(0xFFFF7643);
const kPrimaryColor = Color(0xFF3caea3);
const kPrimaryLightColor = Color(0xFFFFECDF);

const kBlue = Color(0xFF20639b);
const kDarkblue = Color(0xFF173f5f);
const kYellow = Color(0xFFf6d55c);
const kRed = Color(0xFFed553b);
const kGreen = Color(0xFF3caea3);
const kOrange = Color(0xFFFF7643);

const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);

const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kNameNullError = "Please Enter your full name";
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";
const String kEmailAlreadyInUseError = "This email is already in use.";
const String kWeakPasswordError =
    "The password must be 6 characters long or more";

final otpInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 15),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide(color: kTextColor),
  );
}

const String TWITTER_CONSUMER_KEY = "<your consumer key>";
const String TWITTER_CONSUMER_SECRET = "<your consumer secret>";
