import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:productivity_metrics/DataModels/statistics.dart';
import 'package:productivity_metrics/DataModels/user.dart';
import 'package:productivity_metrics/resources/theme_resourses.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:productivity_metrics/Widgets/Settings.dart';

class StatPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StatPageState();
  }
}

class _StatPageState extends State<StatPage> {
  @override
  Widget build(BuildContext context) {
    double pToday =
        User.getInstance().getTaskCompletenessToday(); //todays productivity
    double pWeek =
        User.getInstance().getTaskCompletenessThisWeek(); //weeks productivity
    double pMonth =
        User.getInstance().getTaskCompletenessThisMonth(); //months productivity
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColorProvider.of(context).appColors.primary,
        title: new Text("Productivity Report",
            style: TextStyle(
              color: ThemeColorProvider.of(context).appColors.secondary,
            )),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.settings,
                color: ThemeColorProvider.of(context).appColors.secondary,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SettingsScreen();
                }));
              }),
        ],
      ),
      body: RefreshIndicator(
        //refresh page
        onRefresh: () async {
          await Future.delayed(
              const Duration(seconds: 1, milliseconds: 500), () {});
          setState(() {});
          return;
        },
        child: SingleChildScrollView(
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
                          style: Theme.of(context).textTheme.title,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("Today's Productivity: ${pToday*100}"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 10.0, right: 10.0, bottom: 25.0),
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
                          color: Colors.grey.withOpacity(0.4), width: 4.0)),
                  child: Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 15.0, top: 20.0, left: 10.0),
                          child: Text(
                            "Week",
                            style: Theme.of(context).textTheme.title,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                              "Week's Average Daily Productivity: ${pWeek*100}"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: LinearProgressIndicator(
                            value: pWeek,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("Productivity Over Last Week:"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            height: 250.0,
                            child: charts.TimeSeriesChart(
                              [
                                new charts.Series<DayStats, DateTime>(
                                  id: 'Weekly',
                                  colorFn: (_, __) =>
                                      charts.MaterialPalette.blue.shadeDefault,
                                  domainFn: (DayStats day, _) => day.date,
                                  measureFn: (DayStats day, _) =>
                                      User
                                          .getInstance()
                                          .getTaskCompletenessToday(day: day) *
                                      100,
                                  data: User.getInstance().getWeekly(),
                                )
                              ],
                              animate: true,
                              dateTimeFactory:
                                  const charts.LocalDateTimeFactory(),
                            ),
                          ),
                        ),
                      ]))),
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
                            "Month",
                            style: Theme.of(context).textTheme.title,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                              "30 Day Average Daily Productivity: ${pMonth*100}"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: LinearProgressIndicator(
                            value: pWeek,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("Productivity Over Last 30 Days:"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            height: 250.0,
                            child: charts.TimeSeriesChart(
                              [
                                new charts.Series<DayStats, DateTime>(
                                  id: 'Monthly',
                                  colorFn: (_, __) =>
                                      charts.MaterialPalette.blue.shadeDefault,
                                  domainFn: (DayStats day, _) => day.date,
                                  measureFn: (DayStats day, _) =>
                                      User
                                          .getInstance()
                                          .getTaskCompletenessToday(day: day) *
                                      100,
                                  data: User.getInstance().getMontly(),
                                )
                              ],
                              animate: true,
                              dateTimeFactory:
                                  const charts.LocalDateTimeFactory(),
                            ),
                          ),
                        ),
                      ]))),
            ],
          ),
        ),
      ),
    );
  }
}
