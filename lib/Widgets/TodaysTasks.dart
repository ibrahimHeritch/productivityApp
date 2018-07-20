import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:productivity_metrics/Widgets/ListTaskWidget.dart';
import 'package:productivity_metrics/Widgets/Settings.dart';
import 'package:productivity_metrics/resources/theme_resourses.dart';

class TodaysTasks extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TodaysTasksState();
  }
}

class _TodaysTasksState extends State<TodaysTasks> {
  int _taskCount;
  List<String> Tasks;

  @override
  void initState() {
    Tasks = [
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
    _taskCount = 0;
    return new Scaffold(
        appBar: new AppBar(

          backgroundColor:ThemeColorProvider.of(context).appColors.primary,

          title: new Text("Priductivity Metrics",
              style: TextStyle(
                color: ThemeColorProvider.of(context).appColors.secondary,
              )),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.settings,color: ThemeColorProvider.of(context).appColors.secondary,),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Settings();
                  }));
                }),
            IconButton(icon: Icon(Icons.add), onPressed: () {},color: ThemeColorProvider.of(context).appColors.secondary,)
          ],
        ),
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            ListView(
              children: Tasks.map((task) => _buildTaskWidget(task)).toList(),
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

  void remove(String task) {
    setState(() {
      Tasks.remove(task);
    });
  }

  Widget _buildTaskWidget(String task) {
    _taskCount++;
    return ListTaskWidget(() {
      print("completed");
    }, () {
      print("deleted");
      remove(task);
    }, _taskCount, task);
  }
}
