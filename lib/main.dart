import 'package:flutter/material.dart';
import 'package:productivity_metrics/Widgets/RotaryAnimatedNavigator.dart';
import 'package:productivity_metrics/Widgets/Settings.dart';

import 'package:productivity_metrics/resources/theme_resourses.dart';

final GlobalKey appTheme = GlobalKey();

void main() => runApp(new RootWidget());

class RootWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var app = AppColorTheme(child:ProductivityMetricsApp());
    return app;
  }

}

class ProductivityMetricsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Productivity Metrics",
        home:  new TodaysTasks(),
        theme: ThemeColorProvider.of(context).theme,


      );
  }

}

class TodaysTasks extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TodaysTasksState();
  }
}

class _TodaysTasksState extends State<TodaysTasks> {
  List<String> Tasks = [
    "Test 1", "Test 2", "Test 3", "Test 4", "Test 5", "Test 6", "Test 7"];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
            "Priductivity Metrics", style: TextStyle(color: ThemeColorProvider
            .of(context)
            .appColors
            .secondary,)),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          ListView(
            children: Tasks.map((task) => _buildTaskWidget(task)).toList(),
          ),
          RotaryAnimatedMenu(),
        ],
      ),
    );
  }

  Widget _buildTaskWidget(String task) {
    return ListTile(
      title: Text(task),
      subtitle: Text(task),

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Settings()),
        );
      },
    );
  }
}

