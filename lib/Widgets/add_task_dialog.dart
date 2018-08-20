import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:productivity_metrics/resources/theme_resourses.dart';

class AddTaskDialog extends StatefulWidget {
  TextEditingController _descriptionController;

  TextEditingController get titleController => _titleController;

  TextEditingController get descriptionController => _descriptionController;
  DateTimeWrapper _dt = new DateTimeWrapper()..time=DateTime.now();

  DateTimeWrapper get dt => _dt;


  set descriptionController(TextEditingController value) {
    _descriptionController = value;
  }
  TextEditingController _titleController;

  set titleController(TextEditingController value) {
    _titleController = value;
  }

  AddTaskDialog(key):super(key:key);

  @override
  State<StatefulWidget> createState() {
    return _AddTaskDialogState()..descriptionController=_descriptionController
    ..titleController=_titleController
    ..dt=_dt;
  }
}

class DateTimeWrapper {
  DateTime time;
}

class _AddTaskDialogState extends State<AddTaskDialog> {

  DateTimeWrapper _dt;

  set dt(DateTimeWrapper value) {
    _dt = value;
  }

  TextEditingController _titleController;
  set titleController(TextEditingController value) {
    _titleController = value;
  }

  TextEditingController _descriptionController;

  set descriptionController(TextEditingController value) {
    _descriptionController = value;
  }



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     return SingleChildScrollView(
       child: Column(children: <Widget>[
         TextFormField(
           decoration: InputDecoration(hintText: "Task Title"),
           controller: _titleController,
         ),
         Padding(
           padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
           child: Row(
             children: <Widget>[
               Text("Date: ${_dt.time.day}/${_dt.time.month}/${_dt.time.year}",),
               Padding(
                 padding: const EdgeInsets.all(2.0),
                 child: RaisedButton(
                   color: ThemeColorProvider.of(context).appColors.primary,
                     child: Text("Change"),
                     shape: RoundedRectangleBorder(
                         borderRadius:
                         new BorderRadius.circular(30.0)),
                     onPressed: ()  async{
                       DateTime temp = await showDatePicker(
                           context: context,
                           initialDate: _dt.time,
                           firstDate: DateTime(_dt.time.year),
                           lastDate: DateTime(_dt.time.year + 2));
                       setState(() {
                              if(temp!=null) {
                                _dt.time = temp;
                              }
                            });
                     }),
               ),
             ],
           ),
         )
       ]),
     );
  }
}