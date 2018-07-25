import 'dart:async';

import 'package:flutter/material.dart';
import 'package:productivity_metrics/DataModels/user.dart';
import 'package:productivity_metrics/Widgets/TodaysTasks.dart';
import 'package:productivity_metrics/Widgets/log_in.dart';

import 'package:productivity_metrics/resources/theme_resourses.dart';

final User user = new User.instance();

void main() async{
   await user.initUser();//init user to check if they are logged in
   runApp(new RootWidget());
}

class RootWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var app = AppColorTheme(child: ProductivityMetricsApp());//supplies colors for theme change
    return app;
  }
}

class ProductivityMetricsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget home;
    if (!user.isLoggedin()) {
       home= LoginScreen();
    } else {
      print(user.user);
       home = TodaysTasks();
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Productivity Metrics",
      home: home,
      theme: ThemeColorProvider.of(context).theme,
    );
  }
}
