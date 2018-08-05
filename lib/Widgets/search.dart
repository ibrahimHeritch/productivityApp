import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:productivity_metrics/DataModels/task.dart';
import 'package:productivity_metrics/DataModels/user.dart';
import 'package:productivity_metrics/Widgets/ListTaskWidget.dart';
import 'package:productivity_metrics/Widgets/completed_task_list_widget.dart';
import 'package:productivity_metrics/resources/theme_resourses.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  SearchBar searchBar;

  String searchValue;
  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        iconTheme: IconThemeData(color: ThemeColorProvider.of(context).appColors.secondary ),
        title: new Text('Search',style: TextStyle(color: ThemeColorProvider.of(context).appColors.secondary),),
        actions: [searchBar.getSearchAction(context)],
        backgroundColor: ThemeColorProvider.of(context).appColors.primary,
    );
  }

  _SearchPageState() {
    searchBar = new SearchBar(
        inBar: false,
        setState: setState,
        onSubmitted: search,
        buildDefaultAppBar: buildAppBar
    );
   // searchValue="";
  }
  @override
  Widget build(BuildContext context) {
    Stream stream;
    print(searchValue);
    if(searchValue=="" || searchValue==null){
      stream =Firestore.instance
          .collection("users/${User.getInstance().user.uid}/Tasks")
          .snapshots();
    }else{
      stream =Firestore.instance
          .collection("users/${User.getInstance().user.uid}/Tasks")
          .orderBy("searchValue")
          .startAt([searchValue])
          .endAt([searchValue+"\uf8ff"])
          .snapshots();
    }

    return new Scaffold(
        appBar: searchBar.build(context),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          StreamBuilder(
              stream: stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Text('Loading...');
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data.documents[index];
                        return _buildTaskWidget(
                            ds["text"], index, ds.documentID,ds["isComplete"]);
                      });
                }
              }),
        ],
      ),
    );
  }
  void remove(Task task) {
    DocumentReference dr = Firestore.instance
        .document("users/${User.getInstance().user.uid}/Tasks/${task.id}");
    dr.delete();
  }
  Widget _buildTaskWidget(String task, int index, String id, bool isComplete) {
    Task t = Task(task, index, id,isComplete);
    if(isComplete){
      return ListCompletedTaskWidget(t);
    }else{
      return ListPendingTaskWidget(t, () {
        print("completed");
      }, () {
        print("deleted");
        remove(t);
      });
    }
  }


  void search(String value) {
    searchValue = value.replaceAll(" ", "").toLowerCase();
  }
}