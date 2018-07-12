import 'package:flutter/material.dart';

/**
 * class for saving the different colors themes of the app and initializing them
 * not sure if this is in compliance with flutter convention be=yt it works
 */
class AppColors{
  //used for text icons
  static Color Secondary=Colors.white;

  //used for button backgrounds
  static Color Primary=Colors.orange;

  //used for the background of the rotary Navigator
  static Color primaryOpace=Color.fromRGBO(225, 153, 0, 0.5);

  // theme for MaterialApp
  static var theme=ThemeData.light();

  //this is supossed to change the theme of the app
  //TODO see if this'll work
 static initalizeColors({@required UIColorSchemes scheme=UIColorSchemes.orange}){
   if(scheme==UIColorSchemes.orange){
     theme=ThemeData(primarySwatch: Colors.orange);
     primaryOpace=Color.fromRGBO(225, 153, 0, 0.5);
     Primary=Colors.orange;
     Secondary=Colors.white;
   }else if(scheme==UIColorSchemes.dark){
     theme=ThemeData.dark();
     primaryOpace=Color.fromRGBO(Colors.black.red,Colors.black.green,Colors.black.blue, 0.5);
     Primary=Colors.black87;
     Secondary=Colors.orange;
   }else if(scheme==UIColorSchemes.blue){
     theme=ThemeData(primarySwatch: Colors.blue);
     primaryOpace=Color.fromRGBO(Colors.blue.red,Colors.blue.green,Colors.blue.blue, 0.5);
     Primary=Colors.blue;
     Secondary=Colors.white;
   }else if(scheme==UIColorSchemes.green){
     theme=ThemeData(primarySwatch: Colors.green);
     primaryOpace=Color.fromRGBO(Colors.green.red,Colors.green.green,Colors.green.blue, 0.5);
     Primary=Colors.green;
     Secondary=Colors.white;
   }

  }
  
}
//enum for the different themes available
//TODO add more themes
enum UIColorSchemes{
  orange,
  dark,
  blue,
  green
}