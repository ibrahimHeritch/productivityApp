import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/*
Inherited widget+ theme combo that handles the theme of the app when the user selects
wrap Material app in this the set theme data of MA as the theme specified here
then use the appTheme setter to set theme during runtime
honestly the theme class in flutter could most probably handle this but i wanted to get my hands dirty making some custom inherited widgets
 */

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

  AppColors _appColors = AppColors();

  ThemeData get theme => _theme;

  @override
  Widget build(BuildContext context) {
    return new ThemeColorProvider(
      appThemeKey: _themeGlobalKey,
      theme: _theme,
      appColors: _appColors,
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

  ThemeColorProvider({this.appColors, appThemeKey, this.theme, child})
      : _appThemeKey = appThemeKey,
        super(child: child);
//magic happens here
  set appTheme(UIColorSchemes theme) {
    switch (theme) {
      case UIColorSchemes.dark:
        (_appThemeKey.currentState as AppThemeState)?.theme = ThemeData.dark();
        break;
      default:
        (_appThemeKey.currentState as AppThemeState)?.theme =
            ThemeData(primarySwatch: Colors.orange);
        break;
    }
  }

  @override
  bool updateShouldNotify(ThemeColorProvider old) {
    return old.theme != theme ||
        old.appColors.primary != appColors.primary ||
        old.appColors.secondary != appColors.secondary;
  }
}

class AppColors {
  ///used for text icons
  Color _secondary = Colors.white;
  Color get secondary => _secondary;

  ///used for button backgrounds
  Color _primary = Color.fromRGBO(237,112 , 58, 0.9);
  Color get primary => _primary;


  UIColorSchemes currentTheme = UIColorSchemes.bright;

  initalizeColors({ UIColorSchemes scheme = UIColorSchemes.bright}) {
    currentTheme = scheme;
    if (scheme == UIColorSchemes.bright) {
      _primary = Color.fromRGBO(237,112 , 58, 0.9);
      _secondary = Colors.white;
    } else if (scheme == UIColorSchemes.dark) {
      _primary = Colors.black45;
      _secondary = Colors.orange;
    }
  }
}

enum UIColorSchemes { bright, dark }
