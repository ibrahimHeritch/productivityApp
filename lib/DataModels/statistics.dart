import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:productivity_metrics/DataModels/user.dart';
///This class has the backend functionality needed to calculate user statistics
class UserStats {
  DayStats today;
  List<DayStats> month;
  List<DayStats> week;
  Future<Null> getToday() async {
    today = DayStats(DateTime.now());
    // calculate todays statistics
    Firestore.instance
        .collection("users/${User
        .getInstance()
        .user
        .uid}/Tasks")
        .where("dueDate",
        isGreaterThanOrEqualTo: DateTime(
            DateTime
                .now()
                .year, DateTime
            .now()
            .month, DateTime
            .now()
            .day),
        isLessThan: DateTime(DateTime
            .now()
            .year, DateTime
            .now()
            .month,
            DateTime
                .now()
                .day)
            .add(Duration(days: 1)))
        .snapshots()
        .listen((dt) {
      List tasks = dt.documents;
      int tasksCompleted = 0;
      for (DocumentSnapshot dr in tasks) {
        if (dr["isComplete"]) {
          tasksCompleted++;
        }
      }
      today.tasksCompleted = tasksCompleted;
      today.tasks = tasks.length;
      //save todays statistics
      Firestore.instance.runTransaction((Transaction t) async {
        Firestore.instance
            .document(
            "users/${User
                .getInstance()
                .user
                .uid}/Statistics/${getTodaysId()}")
            .setData({
          "Habits": today.habits,
          "Tasks": today.tasks,
          "HabitsCompleted": today.habits,
          "TasksCompleted": today.tasksCompleted
        });
      });
    });
    //Delete old tasks (dosent work)
    //TODO
    Firestore.instance
        .collection("users/${User
        .getInstance()
        .user
        .uid}/Tasks")
        .where(
      "dueDate",
      isLessThan: DateTime(
          DateTime
              .now()
              .year, DateTime
          .now()
          .month, DateTime
          .now()
          .day),
    )
        .getDocuments()
        .then((QuerySnapshot qs) {
      qs.documents.map((ds) {
        ds.reference.delete();
      });
    });
    getMonthandWeek();
  }

  ///aka get last 30 days
  Future<Null> getMonthandWeek() async {
    month=List(30);
    week=List(7);
    for(int i=1;i<31;i++){
      DateTime dt=DateTime.now().subtract(Duration(days: i));
      Firestore.instance.document("users/${User
          .getInstance()
          .user
          .uid}/Statistics/${getMillisecondsOfToday(dt)}").snapshots().listen((ds){
        if(ds.exists){
          month[29-(i-1)]=DayStats(dt,tasks:ds["Tasks"],tasksCompleted: ds["TasksCompleted"],habits: ds["Habits"],habitsCompleted: ds["HabitsCompleted"]);
        }else{
          month[29-(i-1)]=DayStats(dt);
        }
        if(i<8){
          week[i-1]=month[29-(i-1)];
        }
      });
    }

  }


  String getTodaysId() {
    DateTime dt = DateTime.now();
    return "${getMillisecondsOfToday(dt)}";
  }

  static int getMillisecondsOfToday(DateTime dt) {
    return dt.millisecondsSinceEpoch -
        (dt.millisecondsSinceEpoch % (24 * 60 * 60 * 1000));
  }

  UserStats();

  static double roundToPrecision(double result){
    int decimals = 2;
    int fac = pow(10, decimals);
    return (result * fac).round() / fac;
  }

}
///class to store a days statistic
class DayStats {
  int tasks;
  int tasksCompleted;
  int habits;
  int habitsCompleted;
  DateTime date;

  @override
  String toString() {
    return 'DayStats{tasks: $tasks, tasksCompleted: $tasksCompleted, habits: $habits, habitsCompleted: $habitsCompleted, index: $date}';
  }

  DayStats(
      this.date,
      {this.tasks = 0,
      this.tasksCompleted = 0,
      this.habits = 0,
      this.habitsCompleted = 0,}

  );
}
