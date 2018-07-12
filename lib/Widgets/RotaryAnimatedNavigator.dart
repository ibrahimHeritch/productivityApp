import 'package:flutter/material.dart';
import 'package:productivity_metrics/resources/AppColors.dart';

/**
 * This class contains the central navigation button and its animation
 *
 */
//TODO make this generic
class RotaryAnimatedNavigator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new RANState();
  }

}

class RANState extends State<RotaryAnimatedNavigator>
    with SingleTickerProviderStateMixin<RotaryAnimatedNavigator> {
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
        ColorTween(begin: AppColors.Primary, end: AppColors.primaryOpace)
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
                backgroundColor: AppColors.Primary,
                onPressed: () {},
                child: new Icon(Icons.settings, color: AppColors.Secondary,),
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
                backgroundColor: AppColors.Primary,
                onPressed: () {},
                child: new Icon(Icons.trending_up,
                  color: AppColors.Secondary,),
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
                backgroundColor: AppColors.Primary,
                onPressed: () {},
                child: new Icon(Icons.add,
                  color: AppColors.Secondary,),
              ),
            )
        ),
        /*
           search button
         */
        Positioned(
            bottom: 17.0 + (_animation.value * 65), /*+65*/
            height: 54.0,
            width: 54.0,
            child: FractionalTranslation(
              translation: Offset(-0.7, -1.2),
              child: FloatingActionButton(
                backgroundColor: AppColors.Primary,
                onPressed: () {},
                child: new Icon(
                  Icons.search,
                  color: AppColors.Secondary,
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
          onPressed: () {
            if (!isOpen) {
              _animationController.forward();
            } else {
              _animationController.reverse();
            }
            isOpen = !isOpen;
          },
          backgroundColor: AppColors.Primary,
          child: new AnimatedIcon(icon: AnimatedIcons.menu_close,
            progress: _animation,
            color: AppColors.Secondary,),
        ),
      ),
    );
  }

  /**
   * The animation of the round semi opace background
   */
  Widget getTheRoundAnimatedThing(){
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