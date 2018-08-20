import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:productivity_metrics/Widgets/TodaysTasks.dart';
import 'package:productivity_metrics/Widgets/search.dart';
import 'package:productivity_metrics/Widgets/statistics_page.dart';
import 'package:productivity_metrics/resources/theme_resourses.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  List<Widget> children=[StatPage(),TodaysTasks(),SearchPage()];

  int index =1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: children[index],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            title: Text("Stats"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), title: Text("Search")),
        ],
        currentIndex: index,
        fixedColor: Colors.orange,
      ),
    );

  }
  void onTabTapped(int index) {
    setState(() {
      this.index = index;
    });
  }
}
