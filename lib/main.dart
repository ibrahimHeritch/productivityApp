
import 'package:android_job_scheduler/android_job_scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:productivity_metrics/DataModels/user.dart';
import 'package:productivity_metrics/Widgets/home.dart';
import 'package:productivity_metrics/Widgets/log_in.dart';
import 'package:productivity_metrics/resources/theme_resourses.dart';

void main() async{
   await User.getInstance().initUser();//init user to check if they are logged in
   runApp(new RootWidget());
   AndroidJobScheduler.scheduleOnce(//TODO logged out safety
        Duration(milliseconds: 86400001-(DateTime.now().millisecondsSinceEpoch%86400000)), 42, Job,persistentAcrossReboots: true);
}
void Job()async{
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
      importance: Importance.Max, priority: Priority.High);
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
  var platformChannelSpecifics = new NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
  0, 'Started', DateTime.now().toString(), platformChannelSpecifics,
  payload: 'item id 2');
User.getInstance().initStats();
AndroidJobScheduler.scheduleOnce(//TODO logged out safety
     Duration(milliseconds: 86400000-(DateTime.now().millisecondsSinceEpoch%86400000)), 43, Job,persistentAcrossReboots: true);

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
      User.getInstance().initStats();

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
