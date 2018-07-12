import 'package:flutter/material.dart';

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
    isOpen=false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children;
    if(_animation.value==1){
      children=[
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            height: 65.0 +  (2 * _animation.value*66),
            width: 65.0 +  (2 * _animation.value*66),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.orangeAccent,),
          ),
        ),

        Positioned(
          bottom: 20.0 +(_animation.value * 65),/*+65*/
          height: 65.0,
          width: 65.0,
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: FloatingActionButton(
              onPressed: () {
                if(!isOpen){
                  _animationController.forward();
                }else{
                  _animationController.reverse();
                }
                isOpen=!isOpen;

              },
              backgroundColor: Colors.orange,
              child: new AnimatedIcon(icon: AnimatedIcons.menu_close, progress: _animation,color: Colors.white,),
            ),
          ),
        ),
        Positioned(
            bottom: 17.0 +(_animation.value * 65),/*+65*/
            height: 54.0,
            width: 54.0,
            child:FractionalTranslation(
              translation:Offset(-1.2,0.0),
              child:FloatingActionButton(
                  onPressed: (){},
                  child: new Icon(Icons.settings,color: Colors.white,),
              ),
            )
        ),
        Positioned(
            bottom: 17.0 +(_animation.value * 65),/*+65*/
            height: 54.0,
            width: 54.0,
            child:FractionalTranslation(
              translation:Offset(1.2,0.0),
              child:FloatingActionButton(
                  onPressed: (){},
                  child: new Icon(Icons.trending_up,
                    color: Colors.white,),
              ),
            )
        ),
        Positioned(
            bottom: 17.0 +(_animation.value * 65),/*+65*/
            height: 54.0,
            width: 54.0,
            child:FractionalTranslation(
              translation:Offset(0.7,-1.2),
              child:FloatingActionButton(
                  onPressed: (){},
                  child: new Icon(Icons.add,
                    color: Colors.white,),
              ),
            )
        ),
        Positioned(
            bottom: 17.0 +(_animation.value * 65),/*+65*/
            height: 54.0,
            width: 54.0,
            child:FractionalTranslation(
              translation:Offset(-0.7,-1.2),
              child:FloatingActionButton(
                  onPressed: (){},
                  child: new Icon(
                      Icons.search,
                      color: Colors.white,
                  ),

              ),
            )
        ),
      ];
    }else{
      children=[Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          height: 65.0 +  (2 * _animation.value*66),
          width: 65.0 +  (2 * _animation.value*66),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.orangeAccent,),
        ),
      ),

    Positioned(
    bottom: 20.0 +(_animation.value * 65),/*+65*/
    height: 65.0,
    width: 65.0,
    child: Padding(
    padding: const EdgeInsets.all(0.0),
    child: FloatingActionButton(
    onPressed: () {
    if(!isOpen){
    _animationController.forward();
    }else{
    _animationController.reverse();
    }
    isOpen=!isOpen;

    },
    backgroundColor: Colors.orange,
        child: new AnimatedIcon(icon: AnimatedIcons.menu_close, progress: _animation , color: Colors.white,),
    ),
    ),
    )];
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

}