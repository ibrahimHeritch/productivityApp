import 'package:flutter/material.dart';
import 'package:productivity_metrics/Widgets/log_in.dart';
import 'package:productivity_metrics/main.dart';
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
                  DropdownButton<String>(
                    // value: "Select",
                    items: <String>["Dark", "Blue", "Green", "Orange", "red"]
                        .map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (_value) {
                      if (_value == "Dark") {
                        //TODO add more themes possibly extract init
                        ThemeColorProvider.of(context).appTheme =
                            UIColorSchemes.dark;
                        ThemeColorProvider
                            .of(context)
                            .appColors
                            .initalizeColors(scheme: UIColorSchemes.dark);
                      } else if (_value == "Blue") {
                        ThemeColorProvider.of(context).appTheme =
                            UIColorSchemes.blue;
                        ThemeColorProvider
                            .of(context)
                            .appColors
                            .initalizeColors(scheme: UIColorSchemes.blue);
                      } else if (_value == "Green") {
                        ThemeColorProvider.of(context).appTheme =
                            UIColorSchemes.green;
                        ThemeColorProvider
                            .of(context)
                            .appColors
                            .initalizeColors(scheme: UIColorSchemes.green);
                      } else if (_value == "Orange") {
                        ThemeColorProvider.of(context).appTheme =
                            UIColorSchemes.orange;
                        ThemeColorProvider
                            .of(context)
                            .appColors
                            .initalizeColors(scheme: UIColorSchemes.orange);
                      } else if (_value == "red") {
                        ThemeColorProvider.of(context).appTheme =
                            UIColorSchemes.red;
                        ThemeColorProvider
                            .of(context)
                            .appColors
                            .initalizeColors(scheme: UIColorSchemes.red);
                      }
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
                    "LogOut:",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  RaisedButton(
                    color: ThemeColorProvider.of(context).appColors.primary,
                    child: new Text("Log out"),
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    onPressed: () async {
                      await user.logOut();
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
}
