import 'package:flutter/material.dart';
import 'package:productivity_metrics/Widgets/Settings.dart';
import 'package:productivity_metrics/resources/theme_resourses.dart';

/**
 * This class contains the central menu button and its animation
 *
 */
//TODO make this generic
//TODO Fix background of the round thingy
class RotaryAnimatedMenu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new RANState();
  }

}

class RANState extends State<RotaryAnimatedMenu>
    with SingleTickerProviderStateMixin<RotaryAnimatedMenu> {
  AnimationController _animationController;
  Animation<double> _animation;
  Animation<Color> _colorAnimation;
  bool isOpen;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 250));
    _animation =
    CurvedAnimation(parent: _animationController, curve: Curves.easeIn)
      ..addListener(() {
        setState(() {});
      });
    _colorAnimation =
        ColorTween(begin: /*ColorProvider.of(context).appColors.Primary*/Colors.grey, end: Colors.grey.withOpacity(0.5))
            .animate(_animationController);

    isOpen = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children;
    if (_animation.value == 1) {
      children = [
        getTheRoundAnimatedThing(),
        getCentralFloatingButton(),
        /*
          settings button
         */
        Positioned(
            bottom: 17.0 + (_animation.value * 65), /*+65*/
            height: 54.0,
            width: 54.0,
            child: FractionalTranslation(
              translation: Offset(-1.2, 0.0),
              child: FloatingActionButton(
                heroTag: null,
                backgroundColor: ThemeColorProvider.of(context).appColors.primary,
                onPressed: () {
                  _animationController.reverse();
                  isOpen=!isOpen;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Settings()),
                  );
                },
                child: new Icon(Icons.settings, color: ThemeColorProvider.of(context).appColors.secondary,),
              ),
            )
        ),
        /*
           Statistics button
         */
        Positioned(
            bottom: 17.0 + (_animation.value * 65), /*+65*/
            height: 54.0,
            width: 54.0,
            child: FractionalTranslation(
              translation: Offset(1.2, 0.0),
              child: FloatingActionButton(
                heroTag: null,
                backgroundColor: ThemeColorProvider.of(context).appColors.primary,
                onPressed: () {},
                child: new Icon(Icons.trending_up,
                  color: ThemeColorProvider.of(context).appColors.secondary,),
              ),
            )
        ),
        /*
          add button
         */
        Positioned(
            bottom: 17.0 + (_animation.value * 65), /*+65*/
            height: 54.0,
            width: 54.0,
            child: FractionalTranslation(
              translation: Offset(0.7, -1.2),
              child: FloatingActionButton(
                heroTag: null,
                backgroundColor: ThemeColorProvider.of(context).appColors.primary,
                onPressed: () {},
                child: new Icon(Icons.add,
                  color: ThemeColorProvider.of(context).appColors.secondary,),
              ),
            )
        ),
        /*
           search button
         */
        Positioned(
            bottom: 17.0 + (_animation.value * 65),
            height: 54.0,
            width: 54.0,
            child: FractionalTranslation(
              translation: Offset(-0.7, -1.2),
              child: FloatingActionButton(
                heroTag: null,
                backgroundColor: ThemeColorProvider.of(context).appColors.primary,
                onPressed: () {},
                child: new Icon(
                  Icons.search,
                  color: ThemeColorProvider.of(context).appColors.secondary,
                ),

              ),
            )
        ),
      ];
    } else {
      children = [
        getTheRoundAnimatedThing(),
        getCentralFloatingButton(),
      ];
    }
    return Positioned(
      bottom: 0.0 - (_animation.value * 65),
      child: Stack(
        alignment: Alignment.center,
        children: children,
      ),
    );
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /**
   * The central floating button and its animation this button closes and opens the menu
   */
  Widget getCentralFloatingButton() {
    return Positioned(
      bottom: 20.0 + (_animation.value * 66), /*+65*/
      height: 65.0,
      width: 65.0,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: FloatingActionButton(
          heroTag: null,
          onPressed: () {
            if (!isOpen) {
              _animationController.forward();
            } else {
              _animationController.reverse();
            }
            isOpen = !isOpen;
          },
          backgroundColor: ThemeColorProvider.of(context).appColors.primary,
          child: new AnimatedIcon(icon: AnimatedIcons.menu_close,
            progress: _animation,
            color: ThemeColorProvider.of(context).appColors.secondary,),
        ),
      ),
    );
  }

  /**
   * The animation of the round semi opace background
   */
  Widget getTheRoundAnimatedThing() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: 65.0 + (2 * _animation.value * 66),
        width: 65.0 + (2 * _animation.value * 66),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _colorAnimation.value,),
      ),
    );
  }

}