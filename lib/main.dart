import 'package:flutter/material.dart';
import 'package:productivity_metrics/Widgets/RotaryAnimatedNavigator.dart';
import 'package:productivity_metrics/resources/AppColors.dart';

void main() => runApp(new  ProductivityMetricsApp());
class ProductivityMetricsApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    AppColors.initalizeColors(scheme: UIColorSchemes.orange);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Productivity Metrics",
      theme: AppColors.theme,
      home: new TodaysTasks(),
    );
  }

}

class TodaysTasks extends StatefulWidget{
  @override
  
  State<StatefulWidget> createState() {
    return _TodaysTasksState();
  }
}

class _TodaysTasksState extends State<TodaysTasks> {
  List<String> Tasks= ["Test 1","Test 2","Test 3", "Test 4","Test 5","Test 6","Test 7"];
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            title:new Text("Priductivity Metrics",style:TextStyle(color:AppColors.Secondary,)),
        ),
        body:Stack(
          alignment: Alignment.center,
          children: <Widget>[
             ListView(
               children: Tasks.map((task)=> _buildTaskWidget(task)).toList(),
             ),
             RotaryAnimatedNavigator(),
          ],
        ),
    );
  }

  Widget _buildTaskWidget(String task) {
    return InkWell(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              child:Text(task),
              padding: const EdgeInsets.only(bottom: 60.0,top:20.0,left: 20.0),

            ),
          ],
        ),
        onTap:(){},
    );
  }
}

