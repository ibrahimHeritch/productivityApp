import 'dart:async';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter/material.dart';
import 'package:productivity_metrics/Widgets/TodaysTasks.dart';

import 'package:productivity_metrics/resources/theme_resourses.dart';

final GlobalKey appTheme = GlobalKey();

void main() => runApp(new RootWidget());

class RootWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var app = AppColorTheme(child: ProductivityMetricsApp());
    return app;
  }
}

class ProductivityMetricsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Productivity Metrics",
      home: new TodaysTasks(),
      theme: ThemeColorProvider.of(context).theme,
    );
  }
}
