import 'package:flutter/material.dart';
import 'package:productivity_metrics/resources/theme_resourses.dart';

//TODO better constructors
class ListTaskWidget extends StatefulWidget {
  void Function() _onClickCompleted;
  void Function() _onClickDeleted;
  int _taskCount;

  String _title;

  ListTaskWidget(this._onClickCompleted, this._onClickDeleted,this._taskCount,this._title):super(key:ObjectKey(_title));

  @override
  State<StatefulWidget> createState() {
    return new ListTaskWidgetState(_onClickCompleted, _onClickDeleted,_taskCount,_title);
  }
}

class ListTaskWidgetState extends State<ListTaskWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _animationCont;
  Animation<double> _animation;
  bool _isOpen;
  void Function() _onClickCompleted;
  void Function() _onClickDeleted;
  bool get isOpen => _isOpen;
  int _taskCount;
  String _title;
  ListTaskWidgetState(this._onClickCompleted, this._onClickDeleted,this._taskCount,this._title):super();

  @override
  void initState() {
    _animationCont =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation =
        CurvedAnimation(parent: _animationCont, curve: Curves.decelerate)
          ..addListener(() {
            setState(() {});
          });
    _isOpen = false;
    super.initState();
  }

  @override
  void dispose() {
    _animationCont.dispose();
    super.dispose();
  }

  void Open() {
    if (!_isOpen) {
      _animationCont.forward();
      _isOpen = true;
    }
  }

  void Close() {
    if (_isOpen) {
      _animationCont.reverse();
      _isOpen = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: DecoratedBox(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.2), width: 2.0)),
        child: Stack(
          children: <Widget>[
            InkWell(
              onTap: () {
                if (!_isOpen) {
                  Open();
                } else {
                  Close();
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 80.0 +
                        (_animation.value *
                            (MediaQuery.of(context).size.width - 80)),
                    height: 69.0,
                    color: Colors.grey.withOpacity(0.3),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0)),
                                  color: Colors.transparent,
                                  child: Text(
                                    "Delete",
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: ThemeColorProvider
                                            .of(context)
                                            .appColors
                                            .primary,
                                        fontSize: Theme
                                            .of(context)
                                            .textTheme
                                            .title
                                            .fontSize),
                                  ),
                                  onPressed: _onClickDeleted),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: RaisedButton(
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0)),
                                  color: ThemeColorProvider
                                      .of(context)
                                      .appColors
                                      .primary,
                                  child: Text(
                                    "Completed",
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: ThemeColorProvider
                                            .of(context)
                                            .appColors
                                            .secondary,
                                        fontSize: Theme
                                            .of(context)
                                            .textTheme
                                            .title
                                            .fontSize),
                                  ),
                                  onPressed: _onClickCompleted),
                            ),
                          ),

                          Container(
                            width: 80.0,
                            height: 69.0,
                            child: Center(
                                child: Text(
                              "${_taskCount}",
                              style: Theme.of(context).textTheme.display2,
                            )),
                          ),
                        ]),
                  ),
                  Expanded(
                    child: Container(
                      height: 70.0,
                      child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text("${_title}",
                                    maxLines: 1,
                                    style: Theme.of(context).textTheme.title),
                              ),
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
