import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:productivity_metrics/DataModels/user.dart';

class UserStats {
  DayStats today;
  List<DayStats> month;
  List<DayStats> week;
  Future<Null> getToday() async {
    today = DayStats();
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
    //Delete old tasks
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
    getMonth();
  }

  ///aka get last 30 days
  Future<Null> getMonth() async {
    month=List(30);
    for(int i=1;i<31;i++){
      Firestore.instance.document("users/${User
          .getInstance()
          .user
          .uid}/Statistics/${getMillisecondsOfToday(DateTime.now().subtract(Duration(days: i)))}").snapshots().listen((ds){
        if(ds.exists){
          month[29-(i-1)]=DayStats(tasks:ds["Tasks"],tasksCompleted: ds["TasksCompleted"],habits: ds["Habits"],habitsCompleted: ds["HabitsCompleted"],index: 29-(i-1));
        }else{
          month[29-(i-1)]=DayStats(index: 29-(i-1));
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

}

class DayStats {
  int tasks;
  int tasksCompleted;
  int habits;
  int habitsCompleted;
  int index;

  @override
  String toString() {
    return 'DayStats{tasks: $tasks, tasksCompleted: $tasksCompleted, habits: $habits, habitsCompleted: $habitsCompleted, index: $index}';
  }

  DayStats(
      {this.tasks = 0,
      this.tasksCompleted = 0,
      this.habits = 0,
      this.habitsCompleted = 0,
      this.index=0});
}
