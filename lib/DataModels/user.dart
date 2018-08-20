import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:productivity_metrics/DataModels/statistics.dart';

///user class for authentication
///make sure to call await initUser before using
class User {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  FirebaseUser _user;
  static User _instance;
  int dateTime;
  DateTime day;
  UserStats _stats;



  FirebaseUser get user {
    return _user;
  }
///If a user has been instanciated already return that user else make a new one and return it
  factory User.getInstance(){
    if (_instance == null) {
      _instance = User();
    }
    return _instance;
  }

  User();

  ///create this user from email + password
  Future<Null> createUser(
      {@required String email, @required String password}) async {
    _user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  ///login user
  Future<bool> signInEmail(
      {@required String email, @required String password}) async {
    try {
      _user = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    }catch(e){
      print("hhh"+e.toString());
    }
    initStats();
    return true;
  }

  ///login with google
  Future<Null> signInGoogle() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    _user = await _firebaseAuth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    initStats();
  }

  ///log out
  Future<Null> logOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
    //await _googleSignIn.disconnect();
    _firebaseAuth.currentUser().then((onValue) {
      print(onValue);
    });
    _user = null;
  }

  ///is the user logged in
  bool isLoggedin() {
    return _user != null;
  }

  /// sign in through google silently
  Future<Null> signInGoogleSilently() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signInSilently();

    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    _user = await _firebaseAuth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    initStats();
  }

  ///asign currentUser to _user
  Future<FirebaseUser> initUser() async {
    _user = await _firebaseAuth.currentUser();
    return _user;
  }
///if the right day has been initialized in init stats this it used
  ///to know if we should call initStats aka a new day has started
  bool hasTheRightDay() {
    return dateTime == UserStats.getMillisecondsOfDay(DateTime.now())&& _stats!=null && _stats.today!=null;
  }

  Future<Null> initStats() async {
    _stats = UserStats();
    day=DateTime.now();
    dateTime=UserStats.getMillisecondsOfDay(day);
    await _stats.getToday();
  }


///get todays productivity
/// tasks completed/all tasks
/// returns -1 if error, 0 if NaN or not rightDay
  double getTaskCompletenessToday({DayStats day}) {
    num result;
    if(day==null){
      try{
        if(hasTheRightDay()){
          result= _stats.today.tasksCompleted/_stats.today.tasks;
        }else{
          return 0.0;
        }
      }catch( e){
        print(e);
        return -1.0;
      }
    }else{
      result=day.tasksCompleted/day.tasks;
    }
    if(result.isNaN){
       result=0.0;
    }
    
    return UserStats.roundToPrecision(result);
  }
  ///get weeks productivity
  double getTaskCompletenessThisWeek(){
    num sum=0.0;
    for(int i=29;i>29-7;i--){
      sum+=getTaskCompletenessToday(day:_stats.month[i]);
    }
    return UserStats.roundToPrecision(sum/7);
  }
  ///get monthy productivity
  double getTaskCompletenessThisMonth(){
    num sum=0.0;
    for(int i=0;i<_stats.month.length;i++){
      sum+=getTaskCompletenessToday(day:_stats.month[i]);
    }
    return UserStats.roundToPrecision(sum/30);
  }
  ///get a list of productivities for the past week
  List<DayStats> getWeekly(){
    return _stats.week;
}

  ///get a list of productivites for past month
  getMontly() {
   return _stats.month;
  }

}