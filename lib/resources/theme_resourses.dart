import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/*
Inherited widget+ theme combo that handles the theme of the app when the user selects
wrap Material app in this the set theme data of MA as the theme specified here
then use the appTheme setter to set theme during runtime
 */
//TODO not use appColors?
//key refering to the theme
final GlobalKey _themeGlobalKey = new GlobalKey();

class AppColorTheme extends StatefulWidget {

  final Widget child;

  AppColorTheme({
    this.child,
  }) : super(key: _themeGlobalKey);

  @override
  AppThemeState createState() => new AppThemeState();
}

class AppThemeState extends State<AppColorTheme> {

  ThemeData _theme = ThemeData(primarySwatch: Colors.orange);

  set theme(ThemeData value) {
    setState(() {
      _theme = value;
    });


  }

  AppColors _appColors=AppColors();

  ThemeData get theme => _theme;

  @override
  Widget build(BuildContext context) {
    return new ThemeColorProvider(
      appThemeKey: _themeGlobalKey,
      theme: _theme,
      appColors:_appColors,
      child: new Theme(
        data: _theme,
        child: widget.child,
      ),
    );
  }
}

class ThemeColorProvider extends InheritedWidget {

  static ThemeColorProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(ThemeColorProvider);
  }
  final AppColors appColors;
  final ThemeData theme;
  final GlobalKey _appThemeKey;

  ThemeColorProvider({
    this.appColors,
    appThemeKey,
    this.theme,
    child
  }) : _appThemeKey = appThemeKey, super(child: child);
//magic happens here
  set appTheme(UIColorSchemes theme) {
    switch (theme) {
      case UIColorSchemes.dark:
        (_appThemeKey.currentState as AppThemeState)?.theme = ThemeData.dark();
        break;
      case UIColorSchemes.green:
        (_appThemeKey.currentState as AppThemeState)?.theme = ThemeData(primarySwatch: Colors.green);
        break;
      case UIColorSchemes.blue:
        (_appThemeKey.currentState as AppThemeState)?.theme = ThemeData(primarySwatch: Colors.blue);
        break;

      default:
        (_appThemeKey.currentState as AppThemeState)?.theme = ThemeData(primarySwatch: Colors.orange);
        break;
    }
  }

  @override
  bool updateShouldNotify(ThemeColorProvider old) {
    return old.theme!=theme||
        old.appColors.primary!=appColors.primary||
        old.appColors.secondary!=appColors.secondary;
  }

}
class AppColors{
  //used for text icons
  Color _secondary=Colors.white;
  Color get secondary => _secondary;

   //used for button backgrounds
  Color _primary=Colors.orange;
  Color get primary => _primary;

  //used for the background of the rotary Navigator
  Color _primaryOpace=Colors.orange.withOpacity(0.5);
  Color get primaryOpace => _primaryOpace;

  initalizeColors({@required UIColorSchemes scheme=UIColorSchemes.orange}){
    if(scheme==UIColorSchemes.orange){
      _primaryOpace=Colors.orange.withOpacity(0.5);
      _primary=Colors.orange;
      _secondary=Colors.white;
    }else if(scheme==UIColorSchemes.dark){
      _primaryOpace=Color.fromRGBO(Colors.black.red,Colors.black.green,Colors.black.blue, 0.5);
      _primary=Colors.black87;
      _secondary=Colors.orange;
    }else if(scheme==UIColorSchemes.blue){
      _primaryOpace=Color.fromRGBO(Colors.blue.red,Colors.blue.green,Colors.blue.blue, 0.5);
      _primary=Colors.blue;
      _secondary=Colors.white;
    }else if(scheme==UIColorSchemes.green){
      _primaryOpace=Color.fromRGBO(Colors.green.red,Colors.green.green,Colors.green.blue, 0.5);//TODO fix this embarassment
      _primary=Colors.green;
      _secondary=Colors.white;
    }

  }




}
enum UIColorSchemes{
  orange,
  dark,
  blue,
  green
}