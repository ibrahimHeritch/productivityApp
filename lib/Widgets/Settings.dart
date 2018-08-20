import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:productivity_metrics/DataModels/user.dart';
import 'package:productivity_metrics/Widgets/loading_screen.dart';
import 'package:productivity_metrics/Widgets/log_in.dart';
import 'package:productivity_metrics/resources/theme_resourses.dart';

//TODO: Make this pretty
///setting screen
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        iconTheme: new IconThemeData(
            color: ThemeColorProvider.of(context).appColors.secondary),
        title: new Text(
          "Settings",
          style: TextStyle(
              color: ThemeColorProvider.of(context).appColors.secondary),
        ),
        backgroundColor: ThemeColorProvider.of(context).appColors.primary,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "App theme:",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  themeSelectorButton(context),
                ],
              )),
          Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Notification Settings:",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  Text(
                    "TODO",
                    style: TextStyle(fontSize: 20.0),
                  )
                ],
              )),
          Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Language Settings:",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  Text(
                    "TODO",
                    style: TextStyle(fontSize: 20.0),
                  )
                ],
              )),
          Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Reset Progress:",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  RaisedButton(
                    color: ThemeColorProvider.of(context).appColors.primary,
                    child: new Text("Reset"),
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    onPressed: ()  {
                     showDialog(context: context,
                       builder: (BuildContext context) {
                         return AlertDialog(
                           title: Text(
                               "Are you sure you what to reset all Progress?"),
                             actions: <Widget>[
                           FlatButton(
                             child: new Text("No"),
                             onPressed: () {
                               Navigator.of(context).pop();
                             },
                           ),
                           FlatButton(
                             child: new Text("Reset"),
                             onPressed: (){reset(context);},
                           ),
                         ],
                         );
                       },

                     );
                    },
                  )
                ],
              )),
          Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "LogOut:",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  RaisedButton(
                    color: ThemeColorProvider.of(context).appColors.primary,
                    child: new Text("Log out"),
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    onPressed: () async {
                      User.getInstance().logOut();
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                  )
                ],
              ))
        ],
      ),
    );
  }

  Widget themeSelectorButton(context) {
    if(ThemeColorProvider.of(context).appColors.currentTheme==UIColorSchemes.bright){
      return RaisedButton(
        color: ThemeColorProvider.of(context).appColors.primary,
        child: new Text("Dark"),
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        onPressed: () {
          ThemeColorProvider.of(context).appTheme =
              UIColorSchemes.dark;
          ThemeColorProvider.of(context).appColors.initalizeColors(scheme: UIColorSchemes.dark);

        },
      );
    }else{
      return RaisedButton(
        color: ThemeColorProvider.of(context).appColors.primary,
        child: new Text("Light"),
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        onPressed: () {
          ThemeColorProvider.of(context).appTheme =
              UIColorSchemes.bright;
          ThemeColorProvider.of(context).appColors.initalizeColors(scheme: UIColorSchemes.bright);

        },
      );
    }
  }

  void reset(context) {
    DocumentReference dr = Firestore.instance.document("users/${User
        .getInstance()
        .user
        .uid}");
    dr.delete();
  }
}
