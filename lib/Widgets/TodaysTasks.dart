import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:productivity_metrics/DataModels/task.dart';
import 'package:productivity_metrics/DataModels/user.dart';
import 'package:productivity_metrics/Widgets/ListTaskWidget.dart';
import 'package:productivity_metrics/Widgets/Settings.dart';
import 'package:productivity_metrics/resources/theme_resourses.dart';
///the main homepage that displays todays taskes
class TodaysTasks extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TodaysTasksState();
  }
}

class _TodaysTasksState extends State<TodaysTasks> {


  @override
  void initState() {
   super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(

          backgroundColor:ThemeColorProvider.of(context).appColors.primary,

          title: new Text("Productivity Metrics",
              style: TextStyle(
                color: ThemeColorProvider.of(context).appColors.secondary,
              )),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.settings,color: ThemeColorProvider.of(context).appColors.secondary,),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SettingsScreen();
                  }));
                }),
            IconButton(icon: Icon(Icons.add), onPressed: () {
              final myController = TextEditingController();
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // return object of type Dialog
                  return AlertDialog(
                    title: new Text("Alert Dialog title"),
                    content: TextFormField(controller: myController,),
                    actions: <Widget>[
                      // usually buttons at the bottom of the dialog
                      new FlatButton(
                        child: new Text("Close"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),

                      new FlatButton(
                        child: new Text("Add Task"),
                        onPressed: () {
                          if(myController.text!=null){
                            String text=myController.text;
                            myController.clear();
                            Firestore.instance.runTransaction((Transaction t) async{
                              Firestore.instance.collection("users/${User.instance().user.uid}/Tasks").add({"text":text});
                            });
                          }

                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },color: ThemeColorProvider.of(context).appColors.secondary,)
          ],
        ),
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            StreamBuilder(

              stream: Firestore.instance.collection("users/${User.instance().user.uid}/Tasks").snapshots(),
              builder: (context, snapshot){
                if(!snapshot.hasData){
                  return const Text('Loading...');
                }else{
                  return ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data.documents[index];
                        return _buildTaskWidget(ds["text"],index,ds.documentID);
                      }
                  );
                }

              }

            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.trending_up),
              title: Text("Stats"),
            ),
            BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home"),),
            BottomNavigationBarItem(
                icon: Icon(Icons.search), title: Text("Search")),
          ],
          currentIndex: 1,
        ),
      );
  }
///remove a task
  void remove(Task task) async{
      DocumentReference dr= await Firestore.instance.document("users/${User.instance().user.uid}/Tasks/${task.id}");
      dr.delete();
  }
///builder for list view
  Widget _buildTaskWidget(String task, int index,String id) {
    Task t=Task(task,index,id);
    return ListTaskWidget(
      t, () {
      print("completed");
    }, () {
      print("deleted");
      remove(t);
    }, index+1, task);
  }
}
