import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:productivity_metrics/DataModels/task.dart';
import 'package:productivity_metrics/DataModels/user.dart';
import 'package:productivity_metrics/Widgets/pending_task_list_widget.dart';
import 'package:productivity_metrics/Widgets/Settings.dart';
import 'package:productivity_metrics/Widgets/add_task_dialog.dart';
import 'package:productivity_metrics/Widgets/completed_task_list_widget.dart';
import 'package:productivity_metrics/resources/theme_resourses.dart';

///the main homepage that displays todays taskes
class TodaysTasks extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TodaysTasksState();
  }
}

class _TodaysTasksState extends State<TodaysTasks> {
  GlobalKey dialog = GlobalKey();
  DateTime dt;
  _TodaysTasksState() {
    SystemChannels.lifecycle.setMessageHandler((msg) async {
      debugPrint('SystemChannels> $msg');
      if (msg == AppLifecycleState.resumed.toString()) {
        //make sure right day is loaded
        if (!User.getInstance().hasTheRightDay()) {
          await User.getInstance().initStats();
          setState(() {dt=DateTime.now();});
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dt = DateTime.now();
    return new Scaffold(
      //App Bar contains title, activities: add task, open settings
      appBar: new AppBar(
        backgroundColor: ThemeColorProvider.of(context).appColors.primary,
        title: new Text("Productivity Metrics",
            style: TextStyle(
              color: ThemeColorProvider.of(context).appColors.secondary,
            )),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.settings,
                color: ThemeColorProvider.of(context).appColors.secondary,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SettingsScreen();
                }));
              }),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAddTaskDialog();
            },
            color: ThemeColorProvider.of(context).appColors.secondary,
          ),

        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          RefreshIndicator(
            //Reload page (page updates automatically except when it doesn't)
            onRefresh: () async {
              await Future.delayed(
                  const Duration(seconds: 1), () {});

              if (!User.getInstance().hasTheRightDay()) {
                await User.getInstance().initStats();
                setState(() {dt=DateTime.now();});
              }
              return;
            },
            child: StreamBuilder(
                stream: Firestore.instance
                    .collection("users/${User
                      .getInstance()
                      .user
                      .uid}/Tasks")
                    .orderBy("dueDate")
                    .orderBy("isComplete", descending: false)
                    .where("dueDate",
                        isGreaterThanOrEqualTo:
                            DateTime(dt.year, dt.month, dt.day),
                        isLessThan: DateTime(dt.year, dt.month, dt.day)
                            .add(Duration(days: 1)))
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    //TODO prevent adding a new task when the page is loading
                    return const Text(
                        'Loading...'); //TODO replace this with something cool
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot ds = snapshot.data.documents[index];
                          return _buildTaskWidget(ds["text"], index,
                              ds.documentID, ds["isComplete"]);
                        });
                  }
                }),
          ),
        ],
      ),
    );
  }

  ///remove a task
  ///deletes task from firestore
  void remove(Task task) {
    DocumentReference dr = Firestore.instance.document("users/${User
        .getInstance()
        .user
        .uid}/Tasks/${task.id}");
    dr.delete();
  }

  ///builder for list view
  Widget _buildTaskWidget(String task, int index, String id, bool isComplete) {
    Task t = Task(task, index, id, isComplete);
    if (isComplete) {
      return ListCompletedTaskWidget(t);
    } else {
      return ListPendingTaskWidget(t, () {
        print("completed");
        complete(t);
      }, () {
        print("deleted");
        remove(t);
      });
    }
  }

  void _showAddTaskDialog() {
    final titleController =
        TextEditingController(); //text controller for the title text
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Add Task"),
          content: AddTaskDialog(dialog)
            ..descriptionController =
                TextEditingController() //TODO remove discription
            ..titleController = titleController,
          actions: <Widget>[
            FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: new Text("Add Task"),
              onPressed: _addTask,
            ),
          ],
        );
      },
    );
  }

  ///Adds a Task to firestore
  void _addTask() {
    AddTaskDialog ad = dialog.currentWidget;
    if (ad.titleController.text != null && ad.titleController.text != "") {
      String text = ad.titleController.text;
      String description = ad.descriptionController.text;
      ad.titleController.clear();
      ad.descriptionController.clear();
      String id =
          DateTime //using homemade id instead of autogenerated id because for some reason the tasks get added twice when the
              //the device is offline using this id the task is still added twice but it gets overrided
              //TODO find a better fix
              .now()
              .millisecondsSinceEpoch
              .toString(); //todo prevent duplicates
      Firestore.instance.runTransaction((Transaction t) async {
        print("this is called");
        Firestore.instance
            .document("users/${User
              .getInstance()
              .user
              .uid}/Tasks/" +
                id)
            .setData({
          "text": text,
          "dueDate": ad.dt.time,
          "description": description,
          "isComplete": false,
          "searchValue": text.replaceAll(" ", "").toLowerCase()
        });
      });
    }
    Navigator.of(context).pop();
  }

  ///marks task as completed
  void complete(Task t) {
    DocumentReference dr = Firestore.instance.document("users/${User
          .getInstance()
          .user
          .uid}/Tasks/${t.id}");
    dr.updateData({"isComplete": true});
  }
}
