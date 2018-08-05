import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:productivity_metrics/DataModels/user.dart';
import 'package:productivity_metrics/resources/theme_resourses.dart';
import 'package:fcharts/fcharts.dart';



class StatPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StatPageState();
  }
}

class _StatPageState extends State<StatPage> {
  List<List<dynamic>> weeklyData = [
    ["MON", 39],
    ["TUE", 45],
    ["WED", 67],
    ["TRS", 57],
    ["FRI", 76],
    ["SAT", 67],
    ["SUN", 78]
  ];

  

  @override
  Widget build(BuildContext context) {
    double pToday=User.getInstance().getTaskCompletenessToday();
    double pWeek=User.getInstance().getTaskCompletenessThisWeek();
    double pMonth=User.getInstance().getTaskCompletenessThisMonth();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColorProvider
            .of(context)
            .appColors
            .primary,
        title: new Text("Productivity Report",
            style: TextStyle(
              color: ThemeColorProvider
                  .of(context)
                  .appColors
                  .secondary,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DecoratedBox(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.grey.withOpacity(0.4), width: 4.0)),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 15.0, top: 20.0, left: 10.0),
                      child: Text(
                        "Today",
                        style: Theme
                            .of(context)
                            .textTheme
                            .title,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Today's Productivity: ${pToday*100}"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: LinearProgressIndicator(
                        value: pToday,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Tasks Achived: ${pToday*100}"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: LinearProgressIndicator(
                        value: pToday,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.grey.withOpacity(0.4), width: 4.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding:
                      EdgeInsets.only(left: 10.0, bottom: 15.0, top: 20.0),
                      child: Text(
                        "Weekly",
                        style: Theme
                            .of(context)
                            .textTheme
                            .title,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Week's Productivity: ${pWeek*100}"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: LinearProgressIndicator(
                        value: pWeek,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Tasks Achived: ${pWeek*100}"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: LinearProgressIndicator(
                        value: pWeek,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Weekly Progress Per Day:"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        height: 180.0,
                        child: LineChart(
                          lines: [
                            new Line<List, String, int>(
                              data: weeklyData,
                              xFn: (day) => day[0] as String,
                              yFn: (day) => day[1] as int,

                            ),

                          ],
                        ),
                      ),
                    ),
                  ],
                )),
            DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.grey.withOpacity(0.4), width: 4.0),
                ),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, bottom: 15.0, top: 20.0),
                        child: Text(
                          "Monthly",
                          style: Theme
                              .of(context)
                              .textTheme
                              .title,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("Today's Productivity: ${pMonth*100}"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: LinearProgressIndicator(
                          value: pMonth,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("Tasks Achived: ${pMonth*100}"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: LinearProgressIndicator(
                          value: pMonth,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("Month Progress Per Day:"),
                      ),
                     Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: 180.0,
                          /*child: LineChart(
                            lines: [
                              new Line<DayStats,int,double>(
                                data: User.getInstance().getMonthly(),
                                xFn: (day) => day.index,
                                yFn: (day) => User.getInstance().getTaskCompleteness(day:day),

                              ),

                            ],
                          ),*/
                        ),
                      ),

                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

 
}