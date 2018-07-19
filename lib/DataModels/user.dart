import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class User {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  FirebaseUser _user;

  FirebaseUser get user => _user;
  //create this user from email + password
  Future<String> createUser(
      {@required String email, @required String password}) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return "Successful Login" + user.displayName;
  }

  //login user
  Future<String> verifyUser(
      {@required String email, @required String password}) async {
    _user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    return "Login Successfull" + _user.displayName;
  }

  //login with google
  Future<String> signInGoogle() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    _user = await _firebaseAuth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return ("Welcome " + _user.displayName);
  }

  void logOut() {
    _user=null;
  }
}
