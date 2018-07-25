import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
///user class for authentication
///make sure to call await initUser before using
class User {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  FirebaseUser _user;
  static User _instance;
  FirebaseUser get user {
    return _user;
  }

  factory User.instance(){
    if(_instance==null){
      _instance=User();
    }
    return _instance;
  }

  User();

  ///create this user from email + password
  Future<String> createUser(
      {@required String email, @required String password}) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return "Successful Login" + user.displayName;
  }

  ///login user
  Future<String> verifyUser(
      {@required String email, @required String password}) async {
    _user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    return "Login Successfull" + _user.displayName;
  }

  ///login with google
  Future<String> signInGoogle() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    _user = await _firebaseAuth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return ("Welcome " + _user.displayName);
  }
///log out
  Future<Null> logOut() async{
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
    //await _googleSignIn.disconnect();
    _firebaseAuth.currentUser().then((onValue){print(onValue);});
    _user=null;
  }
///is the user logged in
  bool isLoggedin() {
    print(_user);
    return _user!=null;
  }
 /// sign in through google silently
  Future<String> signInGoogleSilently() async{
    GoogleSignInAccount googleUser = await _googleSignIn.signInSilently();

    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    _user = await _firebaseAuth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return "yy";
  }
///asign currentUser to _user
  Future<FirebaseUser> initUser()async {
     _user=await _firebaseAuth.currentUser();
     return _user;
  }
}
