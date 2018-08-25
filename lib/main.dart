
import 'package:android_job_scheduler/android_job_scheduler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:productivity_metrics/DataModels/user.dart';
import 'package:productivity_metrics/Pages/home.dart';
import 'package:productivity_metrics/Pages/log_in.dart';
import 'package:productivity_metrics/resources/theme_resourses.dart';

void main() async{
   await User.getInstance().initUser();//init user to check if they are logged in
   await SystemChrome.setPreferredOrientations([ //don't allow landscape mode
     DeviceOrientation.portraitUp,
     DeviceOrientation.portraitDown,
   ]);
   runApp(new RootWidget());

}

///the method that's called by the job scheduler
///this method also schedules a new task
///could have used the scheduleEvery method but my experimentation shows that this way i get more accurate results since scheduleEvery schedules a new task x duration after the one before it is complete thus if the first task was delayed it cant adjust
///for example: if i want a job to be executed every day  at 2 pm and i set a schedulevery 24h if
///the first time the job is called is delayed by 2 hours then the next job will be scheduled 24 hours after that meaning that best case it will be at 4 pm
///while on the other hand doing it this way allows the app to fix delays
///i could have maybe overcome this by using the job scheduler in the java code but i wanted to make this app completely in flutter
void job() async {
  //notification settings
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid =
  new AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS = new IOSInitializationSettings();
  var initializationSettings = new InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      selectNotification: (s){});
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      importance: Importance.Max, priority: Priority.Max);
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
  var platformChannelSpecifics = new NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  //display notification
  await flutterLocalNotificationsPlugin.show(
      0, 'Hello', 'What do you want to accomplish today?',
      platformChannelSpecifics,
  payload: 'item id 2');
  //new day has started thus new stats need to be init
User.getInstance().initStats();
// this schedules a new task
  AndroidJobScheduler.scheduleOnce(
      Duration(milliseconds: 86400000 - (DateTime
          .now()
          .millisecondsSinceEpoch % 86400000)), 42, job,
      persistentAcrossReboots: true);

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
    if (!User.getInstance().isLoggedin()) {
       home= LoginScreen();
    } else {
      User.getInstance().initStats(); //init statistics listeners
      AndroidJobScheduler.scheduleOnce( //set schedule
          Duration(milliseconds: 86400001 - (DateTime
              .now()
              .millisecondsSinceEpoch % 86400000)), 42, job,
          persistentAcrossReboots: true);
       home = HomePage();
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Productivity Metrics",
      home: home,
      theme: ThemeColorProvider.of(context).theme,
    );
  }
}
