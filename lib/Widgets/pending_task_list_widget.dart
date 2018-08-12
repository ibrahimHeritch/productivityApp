import 'package:flutter/material.dart';
import 'package:productivity_metrics/DataModels/task.dart';
import 'package:productivity_metrics/resources/theme_resourses.dart';
///class that has the widget that displays the list pending task
class ListPendingTaskWidget extends StatefulWidget {
  /// call this when completed is pressed
  final void Function() _onClickCompleted;
  ///call this when delete is pressed
  final void Function() _onClickDeleted;
  /// the task to be displayed
  final Task task;

  ListPendingTaskWidget(this.task,this._onClickCompleted, this._onClickDeleted):super(key:ObjectKey(task.id));

  @override
  State<StatefulWidget> createState() {
    return new ListPendingTaskWidgetState(task,_onClickCompleted, _onClickDeleted);
  }
}

class ListPendingTaskWidgetState extends State<ListPendingTaskWidget>
    with SingleTickerProviderStateMixin {
  /// open/close animation
  AnimationController _animationCont;
  Animation<double> _animation;
  bool _isOpen;
  void Function() _onClickCompleted;//todo
  void Function() _onClickDeleted;
  bool get isOpen => _isOpen;
  Task task;
  ///height of this widget (width= fill screen)
  final double _height=80.0;

  ListPendingTaskWidgetState(this.task,this._onClickCompleted, this._onClickDeleted):super();

  @override
  void initState() {
    //define open animation
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

  void open() {
    if (!_isOpen) {
      _animationCont.forward();
      _isOpen = true;
    }
  }

  void close() {
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
                  open();
                } else {
                  close();
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 80.0 +
                        (_animation.value *
                            (MediaQuery.of(context).size.width - 80)),
                    height: _height-1,
                    color: Colors.grey.withOpacity(0.3),
                    child: Row(//the tile with the completed and delete buttons
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
                          //the index of the task
                          Container(
                            width: 80.0,
                            height: _height-1,
                            child: Center(
                                child: Text(
                              "${task.index+1}",
                              style: Theme.of(context).textTheme.display2,
                            )),
                          ),
                        ]),
                  ),
                  //the tile with the title
                  Expanded(
                    child: Container(
                      height: _height,
                      child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text("${task.taskTitle}",
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
