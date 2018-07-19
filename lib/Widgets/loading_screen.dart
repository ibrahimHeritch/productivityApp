
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key key}) : super(key: key);

  @override
  LoadingScreenState createState() => new LoadingScreenState();
}


class LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orangeAccent,
      child: Center(
        child: Text("Loading...",style: Theme.of(context).textTheme.title,),
      ),
    );
  }

}