
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:productivity_metrics/DataModels/task.dart';



class ListCompletedTaskWidget extends StatefulWidget {


  final Task task;

  ListCompletedTaskWidget(this.task):super(key:ObjectKey(task.id));

  @override
  State<StatefulWidget> createState() {
    return new ListCompletedTaskWidgetState(task);
  }
}

class ListCompletedTaskWidgetState extends State<ListCompletedTaskWidget>{

  Task task;
  final double _height=80.0;

  ListCompletedTaskWidgetState(this.task);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 2.0)),
        child: Container(
              width: MediaQuery.of(context).size.width,
              height: _height,
              color: Colors.grey.withOpacity(0.3),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.done, color: Colors.green,size: 60.0,),

              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("${task.taskTitle}",
                    maxLines: 1,
                    style: Theme.of(context).textTheme.title),
              ),
            ],
          ),
        )
    );
  }
}

