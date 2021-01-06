import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jood/constants.dart';
import 'package:rxdart/rxdart.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final PublishSubject loading = PublishSubject();

  AuthenticationService() {
    user = _auth.idTokenChanges();
    profile = user.switchMap((User user) {
      if (user != null)
        return _db
            .collection("users")
            .doc(user.uid)
            .snapshots()
            .map((s) => s.data());
      else
        return Stream.value({});
    });
  }

  Stream<User> user;
  Stream<Map<String, dynamic>> profile;

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String> login({String email, String password}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<String> register({String email, String password}) async {
    await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<UserCredential> signInWithGoogle() async {
    loading.add(true);

    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential userCredentials =
        await FirebaseAuth.instance.signInWithCredential(credential);

    print("✨ Signed In: ${userCredentials.user.displayName}");

    updateUserData(userCredentials.user);
    loading.add(false);
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final AccessToken accessToken = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final FacebookAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(accessToken.token);

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);
  }

  Future<UserCredential> signInWithTwitter() async {
    // Create a TwitterLogin instance
    final TwitterLogin twitterLogin = new TwitterLogin(
      consumerKey: TWITTER_CONSUMER_KEY,
      consumerSecret: TWITTER_CONSUMER_SECRET,
    );

    // Trigger the sign-in flow
    final TwitterLoginResult loginResult = await twitterLogin.authorize();

    // Get the Logged In session
    final TwitterSession twitterSession = loginResult.session;

    // Create a credential from the access token
    final AuthCredential twitterAuthCredential = TwitterAuthProvider.credential(
        accessToken: twitterSession.token, secret: twitterSession.secret);

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance
        .signInWithCredential(twitterAuthCredential);
  }

  Future updateUserData(User user) {
    DocumentReference ref = _db.collection("users").doc(user.uid);
    return ref.set({
      "uid": user.uid,
      "email": user.email,
      "displayName": user.displayName,
      "photoURL": user.photoURL,
      "lastSeen": DateTime.now(),
    });
  }
}

final authService = new AuthenticationService();
