import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:productivity_metrics/Widgets/ListTaskWidget.dart';
import 'package:productivity_metrics/Widgets/RotaryAnimatedNavigator.dart';
import 'package:productivity_metrics/resources/theme_resourses.dart';

class TodaysTasks extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TodaysTasksState();
  }
}

class _TodaysTasksState extends State<TodaysTasks> {
  int _taskCount;
  List<String> Tasks ;

  @override
  void initState() {
    Tasks= [
      "Test 1",
      "Test 2",
      "Test 3",
      "Test 4",
      "Test 5",
      "Test 6",
      "Test 7",
      "Test 8",
      "Test 9",
      "Test 10",
      "Test 11",
      "Test 12",
      "Test 13"
    ];
  }

  @override
  Widget build(BuildContext context) {
    _taskCount=0;
    return new Scaffold(
      appBar: new AppBar(
        //backgroundColor: Colors.orange,

        title: new Text("Priductivity Metrics",
            style: TextStyle(
              color: ThemeColorProvider.of(context).appColors.secondary,
            )),
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
  void remove(String task){

    setState(() {
      Tasks.remove(task);
    });
  }
  Widget _buildTaskWidget(String task) {
    _taskCount++;
    return ListTaskWidget((){print("completed");},(){print("deleted");remove(task);},_taskCount,task);
  }
}
